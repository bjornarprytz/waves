shader_type spatial;
render_mode blend_add, unshaded, cull_disabled;

uniform vec3 honk_color : source_color = vec3(1.0, 0.9, 0.3);
uniform float expansion : hint_range(0.0, 1.0) = 0.0; // Animate from 0 to 1
uniform float wave_count : hint_range(1.0, 10.0) = 3.0;
uniform float opacity : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    // Use radial distance from center
    vec2 center_offset = UV - vec2(0.5);
    float dist = length(center_offset) * 2.0; // 0 at center, 1 at edge
    
    // Create concentric wave rings
    float wave_pattern = sin(dist * wave_count * 2.0 * PI - expansion * PI * 2.0);
    wave_pattern = (wave_pattern + 1.0) * 0.5; // 0 to 1
    
    // Fade at edges and with expansion
    float edge_fade = smoothstep(1.0, 0.7, dist);
    float expansion_fade = 1.0 - expansion;
    
    float alpha = wave_pattern * edge_fade * expansion_fade * opacity;
    
    ALBEDO = honk_color;
    ALPHA = alpha;
    EMISSION = honk_color * alpha;
}
