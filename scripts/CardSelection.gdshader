shader_type canvas_item;

uniform vec4 border_color = vec4(1.0, 1.0, 1.0, 1.0);  // Domyślnie biały
uniform float border_thickness = 30.0;  // Grubość ramki w pikselach
uniform vec2 texture_size = vec2(1.0, 1.0);  // Rozmiar tekstury w pikselach

void fragment() {
    // Współrzędne UV (normalizowane)
    vec2 uv = UV;

    // Oblicz grubość ramki w jednostkach UV na podstawie realnych wymiarów
    float border_x = border_thickness / texture_size.x;
    float border_y = border_thickness / texture_size.y;

    // Pobierz kolor tekstury
    vec4 tex_color = texture(TEXTURE, uv);

    // Rysowanie ramki
    if (uv.x < border_x || uv.x > (1.0 - border_x) || uv.y < border_y || uv.y > (1.0 - border_y)) {
        COLOR = border_color;
    } else {
        COLOR = tex_color;
    }
}
