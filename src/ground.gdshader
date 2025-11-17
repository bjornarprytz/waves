shader_type spatial;

uniform vec3 snow_color : source_color = vec3(0.95, 0.95, 1.0);
uniform vec3 snow_shadow : source_color = vec3(0.7, 0.75, 0.85);
uniform float pixel_size : hint_range(10.0, 1000.0) = 50.0;
uniform float noise_scale : hint_range(1.0, 20.0) = 5.0;
uniform float aspect_ratio : hint_range(0.1, 100.0) = 1.0;

// Better hash function to reduce patterns
float hash(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * vec3(443.897, 441.423, 437.195));
    p3 += dot(p3, p3.yzx + 19.19);
    return fract((p3.x + p3.y) * p3.z);
}

// Layered hash for even better randomness
float layered_hash(vec2 p) {
    float h = hash(p);
    h += hash(p + vec2(123.456, 789.012)) * 0.5;
    h += hash(p * 1.337 + vec2(246.135, 864.297)) * 0.25;
    return fract(h);
}

void fragment() {
    // Pixelate UV coordinates with aspect correction
    vec2 adjusted_uv = UV * vec2(pixel_size * aspect_ratio, pixel_size);
    vec2 pixelated_uv = floor(adjusted_uv) / pixel_size;
    
    // Use layered hash for better randomness
    float variation = layered_hash(floor(adjusted_uv) * noise_scale);
    
    // Mix between two snow colors based on noise
    vec3 color = mix(snow_shadow, snow_color, variation);
    
    ALBEDO = color;
    ROUGHNESS = 0.95;
    METALLIC = 0.0;
}