shader_type spatial;
render_mode unshaded;

uniform vec3 moon_color : source_color = vec3(0.95, 0.95, 1.0);
uniform float crater_intensity : hint_range(0.0, 1.0) = 0.3;
uniform float crater_scale : hint_range(1.0, 20.0) = 8.0;
uniform float moon_phase : hint_range(0.0, 1.0) = 0.5; // 0 = new moon, 0.5 = full moon, 1 = new moon

// Noise function for craters
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void fragment() {
    // Use UV coordinates for crater pattern
    vec2 uv = UV;
    
    // Create crater-like patterns with layered noise
    float crater_noise = noise(uv * crater_scale);
    crater_noise += noise(uv * crater_scale * 2.0) * 0.5;
    crater_noise += noise(uv * crater_scale * 4.0) * 0.25;
    crater_noise /= 1.75;
    
    // Moon surface color variation (darker craters, brighter highlands)
    vec3 surface_color = moon_color * (1.0 - crater_intensity + crater_noise * crater_intensity);
    
    // Calculate sun direction from moon_phase (rotates around horizontal plane)
    float phase_angle = moon_phase * 2.0 * PI;
    vec3 sun_direction = vec3(cos(phase_angle), 0.0, sin(phase_angle));
    
    // Calculate lighting from sun direction
    vec3 normal = normalize(NORMAL);
    vec3 light_dir = normalize(sun_direction);
    float light = max(0.0, dot(normal, light_dir));
    
    // Add ambient light so dark side isn't completely black
    light = max(light, 0.05);
    
    ALBEDO = surface_color * light;
}
