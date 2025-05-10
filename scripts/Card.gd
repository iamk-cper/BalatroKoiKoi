extends Control
class_name Card

# Eksportowana właściwość z własnym setterem (składnia Godot 4.x)
#@export var image_path: String = "":
	#set = set_image_path      # <- setter ustawiony w bloku właściwości
var image_path: String = "";
var card_id: String = "";
var card_month: String = "";
var card_type: String = "";

@onready var _tex_rect: TextureRect = $"CardImage"

func set_image_path() -> void:

	var tex := load(image_path)
	if tex:
		_tex_rect.texture = tex
	else:
		push_error("Card.gd: nie udało się wczytać tekstury %s" % image_path)

func card_info() -> String:
	return "Karta: " + card_id + " Miesiąc: " + card_month + " Typ: " + card_type + " Ścieżka obrazka: " + image_path
