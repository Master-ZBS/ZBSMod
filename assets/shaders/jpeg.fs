#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define PRECISION highp
#else
	#define PRECISION mediump
#endif

//
// JPEG-style shader (block compression + color quantization + chroma subsampling)
// based on stupxd base
//

extern PRECISION vec2 jpeg;

//uniform float jpeg; // this must exist

extern PRECISION number dissolve;
// (sprite_pos_x, sprite_pos_y, sprite_width, sprite_height) [not normalized]
// (width, height) for atlas texture [not normalized]
extern PRECISION vec4 burn_colour_1;
extern PRECISION vec4 burn_colour_2;

// [Required] 
// Apply dissolve effect (when card is being "burnt", e.g. when consumable is used)
vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv);

uniform float compressamount = 6.0;

extern PRECISION number time;

extern PRECISION vec4 texture_details;
extern PRECISION vec2 image_details;

extern bool shadow;

// ---------------------------------------------
// CORE JPEG EFFECT
// ---------------------------------------------

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    // -----------------------------
    // 1. BLOCK SAMPLING (macroblocks)
    // -----------------------------
    float block_size = compressamount;

    vec2 uv_pixels =
    (texture_coords * image_details)
    - (texture_details.xy * texture_details.ba);

uv_pixels = floor(uv_pixels / compressamount) * compressamount;

vec2 uv =
    uv_pixels / texture_details.ba
    + texture_details.xy;

    // -----------------------------
    // 2. SAMPLE BASE COLOR
    // -----------------------------
    vec4 tex = Texel(texture, uv);

    // -----------------------------
    // 3. CHROMA SUBSAMPLING (fake JPEG color blur)
    // -----------------------------
    vec2 chroma_uv = texture_coords * image_details;
    chroma_uv = floor(chroma_uv / (block_size * 2.0)) * (block_size * 2.0);
    chroma_uv /= image_details;

    vec3 chroma = Texel(texture, chroma_uv).rgb;

    float luma = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
    tex.rgb = mix(vec3(luma), chroma, 1.15);

    // -----------------------------
    // 4. COLOR QUANTIZATION (banding)
    // -----------------------------
    float levels = 32.0; // lower = more JPEG compression
    tex.rgb = floor(tex.rgb * levels) / levels;

    // -----------------------------
    // 5. SUBTLE DECODING NOISE
    // -----------------------------
    float jitter = sin(time * 12.0 + texture_coords.y * 80.0) * 0.002;
    uv.x += jitter;

    // re-apply quantization after jitter sample
    tex.rgb = floor(tex.rgb * levels) / levels;

    // -----------------------------
    // 6. VIGNETTE (subtle compression darkening)
    // -----------------------------
    vec2 center = texture_coords - 0.5;
    float vignette = 1.0 - dot(center, center) * 1.4;
    tex.rgb *= clamp(vignette, 0.75, 1.0);

    // -----------------------------
    // 7. GRAIN (JPEG sensor noise feel)
    // -----------------------------
    float grain = fract(sin(dot(texture_coords + time, vec2(12.9898, 78.233))) * 43758.5453);
    tex.rgb += (grain - 0.5) * 0.03;

    // Does not do anything. Required for shader to not crash.
    if (uv.x > 2. * uv.x) {
        uv = jpeg;
    }

    // required
	return dissolve_mask(tex*colour, texture_coords, uv);
}

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, shadow ? tex.a*0.3: tex.a);
    }

    float adjusted_dissolve = (dissolve*dissolve*(3.-2.*dissolve))*1.02 - 0.01; //Adjusting 0.0-1.0 to fall to -0.1 - 1.1 scale so the mask does not pause at extreme values

	float t = time * 10.0 + 2003.;
	vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);
	
	vec2 field_part1 = uv_scaled_centered + 50.*vec2(sin(-t / 143.6340), cos(-t / 99.4324));
	vec2 field_part2 = uv_scaled_centered + 50.*vec2(cos( t / 53.1532),  cos( t / 61.4532));
	vec2 field_part3 = uv_scaled_centered + 50.*vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field = (1.+ (
        cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
        cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92) ))/2.;
    vec2 borders = vec2(0.2, 0.8);

    float res = (.5 + .5* cos( (adjusted_dissolve) / 82.612 + ( field + -.5 ) *3.14))
    - (floored_uv.x > borders.y ? (floored_uv.x - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y > borders.y ? (floored_uv.y - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.x < borders.x ? (borders.x - floored_uv.x)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y < borders.x ? (borders.x - floored_uv.y)*(5. + 5.*dissolve) : 0.)*(dissolve);

    if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
        if (!shadow && res < adjusted_dissolve + 0.5*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
            tex.rgba = burn_colour_1.rgba;
        } else if (burn_colour_2.a > 0.01) {
            tex.rgba = burn_colour_2.rgba;
        }
    }

    return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a*0.3: tex.a) : .0);
}

// ---------------------------------------------
// VERTEX (unchanged from your base)
// ---------------------------------------------

extern PRECISION vec2 mouse_screen_pos;
extern PRECISION float hovering;
extern PRECISION float screen_scale;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position)
{
    if (hovering <= 0.)
        return transform_projection * vertex_position;

    float mid_dist = length(vertex_position.xy - 0.5 * love_ScreenSize.xy) / length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy) / screen_scale;

    float scale = 0.2 * (-0.03 - 0.3 * max(0., 0.3 - mid_dist))
                * hovering * (length(mouse_offset) * length(mouse_offset)) / (2. - mid_dist);

    return transform_projection * vertex_position + vec4(0, 0, 0, scale);
}
#endif