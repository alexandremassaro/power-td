shader_type spatial;

uniform vec4 albedo_color : source_color = vec4(1.0, 0.0, 1.0, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.

	ALBEDO = albedo_color.rgb; 
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
