extends TextureRect

# kolor i grubość ramki
var border_color: Color = Color.YELLOW
var border_thickness: int = 2

func _draw() -> void:
	# TextureRect sam narysuje texture, potem _draw() dorysuje ramkę
	if texture:
		draw_rect(Rect2(Vector2.ZERO, get_texture().get_size()), border_color, false, border_thickness)
