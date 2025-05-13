extends Control

#@export var card_slots_hand: PackedScene     = preload("res://scenes/CardSlotsHand.tscn")

# Węzły typu TextureRect
@onready var texture1 = $SwapButton
@onready var texture2 = $PairButton
@onready var switch_button = $Button

# Aktualny stan widoczności
var is_texture1_visible: bool = false
var pair_state: bool = true

func _ready():
	# Przypisanie sygnału do przycisku
	switch_button.pressed.connect(_on_button_pressed)
	texture2.visible = false
	texture2.modulate.a = 0.0  # 0% widoczność


# Funkcja zmiany widoczności
func _on_button_pressed():
	# Przełączenie stanu widoczności
	is_texture1_visible = !is_texture1_visible
	pair_state = !pair_state
	_update_visibility()

# Aktualizacja widoczności obu TextureRect
func _update_visibility():
	var card_slots_hand = get_tree().get_root().get_node("Game/CardManager/CardSlotsHand")
	var card_slots_table = get_tree().get_root().get_node("Game/CardManager/CardSlotsTable")
	if is_texture1_visible:
		texture1.visible = false
		texture1.modulate.a = 0.0  # 100% widoczność
		texture2.visible = true
		texture2.modulate.a = 1.0  # 0% widoczność
		card_slots_hand.selection_limit = 4
		card_slots_table.selection_limit = 0
		if card_slots_table.selection_limit < card_slots_table.selected_number:
			card_slots_table.clear_selection()
	else:
		texture1.visible = true
		texture1.modulate.a = 1.0  # 0% widoczność
		texture2.visible = false
		texture2.modulate.a = 0.0  # 100% widoczność
		card_slots_hand.selection_limit = 1
		card_slots_table.selection_limit = 1
		if card_slots_hand.selection_limit < card_slots_hand.selected_number:
			card_slots_hand.clear_selection()
