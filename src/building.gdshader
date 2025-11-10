shader_type spatial;

uniform sampler2D albedo_texture : source_color;
uniform vec4 edge_color : source_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform vec4 base_color : source_color = vec4(0.1, 0.0, 0.2, 1.0);
uniform float edge_thickness : hint_range(0.0, 1.0) = 0.3;
uniform float edge_glow : hint_range(0.0, 5.0) = 2.0;

void fragment() {
    // Sample the texture
    vec4 texture_color = texture(albedo_texture, UV);
    
    // Get the normal in view space
    vec3 normal = normalize(NORMAL);
    vec3 view = normalize(VIEW);
    
    // Fresnel effect - edges facing away from camera
    float fresnel = 1.0 - abs(dot(normal, view));
    fresnel = pow(fresnel, 1.0 / edge_thickness);
    
    // Combine texture with base color and instance color
    vec3 tinted_base = texture_color.rgb * base_color.rgb * COLOR.rgb;
    
    // Mix base color with edge color based on fresnel
    vec3 final_color = mix(tinted_base, edge_color.rgb, fresnel);
    
    // Add emission to edges for glow
    ALBEDO = final_color;
    EMISSION = edge_color.rgb * fresnel * edge_glow;
}
