shader_type spatial;
render_mode unshaded, blend_mix, cull_back;

uniform sampler2D mountain_texture : source_color, filter_linear;
uniform vec3 moon_color : source_color = vec3(0.95, 0.95, 1.0);
uniform vec3 moon_direction = vec3(0.5, 0.5, -0.5); // Direction to the moon
uniform float moonlight_intensity : hint_range(0.0, 2.0) = 0.5;

void fragment() {
    // Sample the mountain texture
    vec4 tex = texture(mountain_texture, UV);
    
    // Calculate moonlight effect based on surface normal facing the moon
    vec3 normal = NORMAL;
    float moonlight_factor = max(0.0, dot(normalize(normal), normalize(moon_direction)));
    moonlight_factor = pow(moonlight_factor, 2.0);
    
    // Tint the texture with moonlight
    vec3 moonlight_tint = mix(vec3(1.0), moon_color, moonlight_factor * moonlight_intensity);
    vec3 final_color = tex.rgb * moonlight_tint;
    
    ALBEDO = final_color;
    ALPHA = tex.a;
}
