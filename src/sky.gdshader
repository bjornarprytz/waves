shader_type sky;

uniform vec3 horizon_color : source_color = vec3(0.545, 0.0, 1.0);
uniform vec3 sky_color : source_color = vec3(0.063, 0.0, 0.173);
uniform vec3 star_color : source_color = vec3(1.0, 1.0, 1.0);

uniform float star_density : hint_range(0.0, 1.0) = 0.3;
uniform float star_brightness : hint_range(0.0, 2.0) = 1.0;

// Simple hash function for pseudo-random values
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

vec2 hash2(vec2 p) {
    return fract(sin(vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)))) * 43758.5453);
}

// Noise function
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

// Generate stars with smooth falloff
float stars(vec2 uv, float threshold) {
    vec2 cell = floor(uv * 200.0);
    vec2 local_uv = fract(uv * 200.0);
    
    float star = 0.0;
    
    // Check current cell and neighbors for better distribution
    for(int x = -1; x <= 1; x++) {
        for(int y = -1; y <= 1; y++) {
            vec2 neighbor = cell + vec2(float(x), float(y));
            vec2 point = hash2(neighbor);
            
            // Random chance for a star to exist in this cell
            float exists = step(1.0 - threshold, hash(neighbor + vec2(3.0, 7.0)));
            
            // Calculate distance from point in cell
            vec2 star_pos = point + vec2(float(x), float(y)) - local_uv;
            float dist = length(star_pos);
            
            // Smooth star with size variation
            float size = 0.015 + hash(neighbor + vec2(5.0, 11.0)) * 0.01;
            float brightness = 0.5 + hash(neighbor + vec2(13.0, 17.0)) * 0.5;
            float star_value = smoothstep(size, 0.0, dist) * exists * brightness;
            
            star = max(star, star_value);
        }
    }
    
    return star;
}

void sky() {
    // Get direction vector and convert to spherical coordinates
    vec3 dir = EYEDIR;
    float elevation = dir.y; // -1 (down) to 1 (up)
    float azimuth = atan(dir.z, dir.x) / (2.0 * PI) + 0.5; // 0 to 1 around horizon
    
    // Base sky gradient
    float horizon_blend = smoothstep(-0.3, 0.3, elevation);
    vec3 base_sky = mix(horizon_color, sky_color, horizon_blend);
    
    // Stars (only in upper hemisphere)
    float star_mask = smoothstep(-0.1, 0.3, elevation);
    // Use direct spherical coordinates without tiling to keep stars fixed
    vec2 star_uv = vec2(azimuth, (elevation + 1.0) * 0.5);
    float star_field = stars(star_uv, star_density) * star_mask * star_brightness;
    vec3 final_sky = base_sky + star_color * star_field;
    
    COLOR = final_sky;
}
