extends Control
class_name CardSlot

@export var card_base_size: Vector2 = Vector2(976, 1600)   # pełny rozmiar karty
@export var display_scale:  float   = 0.08                # miniaturka 8 %

func _ready() -> void:
	# ustawiamy minimalny rozmiar po skalowaniu
	custom_minimum_size = card_base_size * display_scale
