shader_type spatial;

uniform vec3 snow_color : source_color = vec3(0.95, 0.95, 1.0);
uniform vec3 snow_shadow : source_color = vec3(0.7, 0.75, 0.85);
uniform vec3 track_color : source_color = vec3(0.8, 0.82, 0.9);
uniform float track_width : hint_range(0.1, 0.5) = 0.3;
uniform float drift_scale : hint_range(5.0, 30.0) = 15.0;
uniform float sparkle_amount : hint_range(0.0, 1.0) = 0.3;

// Hash function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
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

void fragment() {
    vec2 uv = UV;
    float u = fract(uv.x);
    
    // Base snow color
    vec3 color = snow_color;
    
    // Snow drifts (subtle height variation)
    float drift = noise(uv * drift_scale);
    drift += noise(uv * drift_scale * 2.0) * 0.5;
    color = mix(snow_shadow, snow_color, drift);
    
    // Tire/ski tracks down the middle
    float center_dist = abs(u - 0.5);
    float left_track = smoothstep(0.2, 0.18, abs(u - 0.35));
    float right_track = smoothstep(0.2, 0.18, abs(u - 0.65));
    float tracks = max(left_track, right_track);
    
    // Add track texture
    float track_noise = noise(uv * vec2(5.0, 100.0));
    vec3 track_detail = mix(track_color, snow_shadow, track_noise);
    color = mix(color, track_detail, tracks);
    
    // Ice sparkles
    float sparkle = hash(floor(uv * 200.0));
    sparkle = step(1.0 - sparkle_amount * 0.1, sparkle);
    sparkle *= hash(floor(uv * 200.0) + vec2(1.3, 2.7));
    
    color += vec3(sparkle * 0.5);
    
    ALBEDO = color;
    EMISSION = vec3(sparkle * sparkle_amount);
    ROUGHNESS = 0.3;
    METALLIC = 0.0;
}