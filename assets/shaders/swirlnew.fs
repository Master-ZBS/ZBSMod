#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
    #define PRECISION highp
#else
    #define PRECISION mediump
#endif

extern PRECISION vec2 flipped;

extern PRECISION number dissolve;
extern PRECISION number time;

// (sprite_pos_x, sprite_pos_y, sprite_width, sprite_height) [not normalized]
extern PRECISION vec4 texture_details;
// (width, height) for atlas texture [not normalized]
extern PRECISION vec2 image_details;

extern bool shadow;
extern PRECISION vec4 burn_colour_1;
extern PRECISION vec4 burn_colour_2;

// swirl control
extern PRECISION number strength;

// required by Balatro
vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv);

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    // sprite-local UV (0–1 inside card)
    vec2 uv = (((texture_coords) * image_details)
              - texture_details.xy * texture_details.ba)
              / texture_details.ba;

    // center of the card
    vec2 center = vec2(0.5, 0.5);
    vec2 offset = uv - center;

    float dist = length(offset);

    // swirl angle
    float angle = strength * dist * 6.0 + time;

    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);

    vec2 swirled_uv = center + rot * offset;

    // convert back to atlas space
    vec2 atlas_uv =
        (swirled_uv * texture_details.ba + texture_details.xy)
        / image_details;

    vec4 tex = Texel(texture, atlas_uv);

    return dissolve_mask(tex * colour, texture_coords, uv);
}
