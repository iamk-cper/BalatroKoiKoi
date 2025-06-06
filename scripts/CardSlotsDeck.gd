extends Control

@onready var card_manager : Node        = get_parent()   # CardSlotsDeck i CardManager są rodzeństwem

#func _ready() -> void:
	#btn.pressed.connect(_on_draw_pressed)
#
#func _on_draw_pressed() -> void:
	#card_manager.deal_one_card_to_hand()

func show_top() -> void:
	var card: Card = card_manager.get_top_card()
	if card == null:
		print("Brak karty w talii.")
		return

	var texture: Texture2D = load(card.image_path)
	if texture == null:
		push_warning("Nie udało się załadować tekstury z path: %s" % card.image_path)
		return

	var preview_rect: TextureRect = $TextureRect  # <-- zmień na właściwą ścieżkę
	if preview_rect == null:
		push_error("Nie znaleziono TextureRect do podglądu.")
		return

	preview_rect.texture = texture
