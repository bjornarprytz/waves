shader_type spatial;

uniform vec3 road_color : source_color = vec3(0.1, 0.1, 0.1);
uniform vec3 sidewalk_color : source_color = vec3(0.3, 0.3, 0.3);
uniform vec3 line_color : source_color = vec3(1.0, 1.0, 0.0);
uniform vec3 grid_color : source_color = vec3(0.0, 1.0, 1.0);
uniform float line_repeat = 4.0;
uniform float sidewalk_width = 0.2;
uniform float line_width = 0.05;
uniform float scroll_speed = 0.5;
uniform float time_offset;
uniform float grid_intensity : hint_range(0.0, 1.0) = 0.3;
uniform float grid_scale = 20.0;
uniform float edge_glow : hint_range(0.0, 2.0) = 0.5;

void fragment() {
    vec2 uv = UV;
    
    // Split road and sidewalks across X (U axis)
    float u = fract(uv.x); // repeat across the circumference
    float v = fract(uv.y * line_repeat); // repeating pattern along road
    
    // Define the central road section
    float left_sidewalk = sidewalk_width;
    float right_sidewalk = 1.0 - sidewalk_width;
    
    vec3 color = road_color;
    
    // Add grid pattern to road
    vec2 grid_uv = uv * grid_scale;
    float grid_x = abs(fract(grid_uv.x) - 0.5);
    float grid_y = abs(fract(grid_uv.y) - 0.5);
    float grid = step(0.48, max(grid_x, grid_y));
    
    if (u < left_sidewalk || u > right_sidewalk) {
        // Sidewalk region with grid
        color = mix(sidewalk_color, grid_color, grid * grid_intensity * 0.5);
    } else {
        // Road with grid
        color = mix(road_color, grid_color, grid * grid_intensity);
        
        // Road lane lines (e.g., dashed center)
        float line = step(0.5 - line_width * 0.5, abs(u - 0.5));
        float dash = step(0.9, v); // dashed pattern
        if (line < 1.0 && dash > 0.5) {
            color = mix(color, line_color, 1.0);
        }
    }
    
    // Add edge glow at sidewalk boundaries
    float edge_dist = min(abs(u - left_sidewalk), abs(u - right_sidewalk));
    float edge_mask = smoothstep(0.02, 0.0, edge_dist);
    color = mix(color, line_color, edge_mask * edge_glow);

    ALBEDO = color;
    EMISSION = grid_color * grid * grid_intensity * 0.5 + line_color * edge_mask * edge_glow;
}