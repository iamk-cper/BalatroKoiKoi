extends Control

@onready var btn          : Button      = $Button        # popraw ścieżkę, jeśli inna
@onready var card_manager : Node        = get_parent()   # CardSlotsDeck i CardManager są rodzeństwem

func _ready() -> void:
	btn.pressed.connect(_on_draw_pressed)

func _on_draw_pressed() -> void:
	card_manager.deal_one_card_to_hand()
