shader_type spatial;

uniform vec3 road_color : source_color = vec3(0.1, 0.1, 0.1);
uniform vec3 sidewalk_color : source_color = vec3(0.3, 0.3, 0.3);
uniform vec3 line_color : source_color = vec3(1.0, 1.0, 0.0);
uniform float line_repeat = 4.0;
uniform float sidewalk_width = 0.2;
uniform float line_width = 0.05;
uniform float scroll_speed = 0.5;
uniform float time_offset;

void fragment() {
    vec2 uv = UV;
    
    
    // Split road and sidewalks across X (U axis)
    float u = fract(uv.x); // repeat across the circumference
    float v = fract(uv.y * line_repeat); // repeating pattern along road
    
    // Define the central road section
    float left_sidewalk = sidewalk_width;
    float right_sidewalk = 1.0 - sidewalk_width;
    
    vec3 color = road_color;
    
    if (u < left_sidewalk || u > right_sidewalk) {
        // Sidewalk region
        color = sidewalk_color;
    } else {
        // Road lane lines (e.g., dashed center)
        float line = step(0.5 - line_width * 0.5, abs(u - 0.5));
        float dash = step(0.9, v); // dashed pattern
        if (line < 1.0 && dash > 0.5) {
            color = mix(color, line_color, 1.0);
        }
    }

    ALBEDO = color;
}