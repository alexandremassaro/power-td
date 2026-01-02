shader_type spatial;

uniform vec4 base_color : source_color = vec4(1.0);

void light() {
    float NdotL = dot(NORMAL, LIGHT);
    float cel = floor(NdotL * 3.0) / 3.0; // 3 níveis de sombra
    DIFFUSE_LIGHT = ALBEDO * LIGHT_COLOR * max(cel, 0.0);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    ALBEDO = base_color.rgb;
    // Sem sombreamento complexo, cores chapadas
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
