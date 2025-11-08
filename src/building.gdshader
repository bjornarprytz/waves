shader_type spatial;

uniform vec4 edge_color : source_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform vec4 base_color : source_color = vec4(0.1, 0.0, 0.2, 1.0);
uniform float edge_thickness : hint_range(0.0, 1.0) = 0.3;
uniform float edge_glow : hint_range(0.0, 5.0) = 2.0;

void fragment() {
	// Get the normal in view space
	vec3 normal = normalize(NORMAL);
	vec3 view = normalize(VIEW);
	
	// Fresnel effect - edges facing away from camera
	float fresnel = 1.0 - abs(dot(normal, view));
	fresnel = pow(fresnel, 1.0 / edge_thickness);
	
	// Mix base color with edge color based on fresnel
	vec3 final_color = mix(base_color.rgb, edge_color.rgb, fresnel);
	
	// Add emission to edges for glow
	ALBEDO = final_color;
	EMISSION = edge_color.rgb * fresnel * edge_glow;
}
