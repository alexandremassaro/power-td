shader_type spatial;

uniform vec4 color1 : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 color2 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform int grid_width : hint_range(1, 100) = 37;  // Células na largura
uniform int grid_height : hint_range(1, 100) = 37; // Células na altura

void fragment() {
    // Escala UV pelo tamanho da grid
    vec2 uv = UV * vec2(float(grid_width), float(grid_height));
    
    // Padrão xadrez
    float pattern = mod(floor(uv.x) + floor(uv.y), 2.0);
    
    ALBEDO = mix(color1.rgb, color2.rgb, pattern);
}