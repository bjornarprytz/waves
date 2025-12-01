shader_type spatial;
render_mode cull_disabled, depth_prepass_alpha;

uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform vec4 tint_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool flip_texture = false;

void fragment() {
    vec2 uv = UV;
    if (flip_texture) {
        uv.x = 1.0 - uv.x;
    }
    
    vec4 tex = texture(texture_albedo, uv);
    ALBEDO = tex.rgb * tint_color.rgb;
    ALPHA = tex.a * tint_color.a;
}
