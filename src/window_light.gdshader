shader_type spatial;

instance uniform vec4 light_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
instance uniform bool light_on = false;
instance uniform float emission_energy = 8.1;

uniform vec4 base_color : source_color = vec4(0.266575, 0.266575, 0.266575, 1.0);
uniform vec4 emission_base : source_color = vec4(0.458263, 0.250497, 0.072118, 1.0);

void fragment() {
	ALBEDO = base_color.rgb * light_color.rgb;
	
	if (light_on) {
		EMISSION = emission_base.rgb * light_color.rgb * emission_energy;
	} else {
		EMISSION = vec3(0.0);
	}
}
