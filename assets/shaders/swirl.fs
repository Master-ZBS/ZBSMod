//extern vec2 mouse_screen_pos;
//extern PRECISION float hovering;
//extern PRECISION float screen_scale;

extern number time;
extern number strength;   // swirl intensity
extern vec2 resolution;  // texture size

vec4 effect(vec4 color, Image tex, vec2 tex_coords, vec2 screen_coords)
{
	//vec2 _dummy = mouse_screen_pos * 1;
    vec2 center = vec2(0.5, 0.5);
    vec2 uv = tex_coords;

    vec2 offset = uv - center;
    float dist = length(offset);

    float angle = strength * dist * 2.0 + time;

    float s = sin(angle);
    float c = cos(angle);

    mat2 rot = mat2(c, -s, s, c);
    uv = center + rot * offset;

    return Texel(tex, uv) * color;
}


// for transforming the card while your mouse is on it
extern vec2 mouse_screen_pos;
extern float hovering;
extern float screen_scale;

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    if (hovering <= 0.){
        return transform_projection * vertex_position;
    }
    float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    float scale = 0.2*(-0.03 - 0.3*max(0., 0.3-mid_dist))
                *hovering*(length(mouse_offset)*length(mouse_offset))/(2. -mid_dist);

    return transform_projection * vertex_position + vec4(0,0,0,scale);
}
#endif