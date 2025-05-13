extends Control

#@export var card_slots_hand: PackedScene     = preload("res://scenes/CardSlotsHand.tscn")

@onready var switch_button = $Button


func _ready():
	# Przypisanie sygnału do przycisku
	switch_button.pressed.connect(_on_button_pressed)


# Funkcja zmiany widoczności
func _on_button_pressed():
	var mode_button = get_tree().get_root().get_node("Game/GUI/ModeButton")
	var card_slots_hand = get_tree().get_root().get_node("Game/CardManager/CardSlotsHand")
	var card_slots_table = get_tree().get_root().get_node("Game/CardManager/CardSlotsTable")
	if mode_button.pair_state == true && card_slots_hand.selected_cards.size() == 1 && card_slots_table.selected_cards.size() == 1:
		pair()
	elif mode_button.pair_state == false:
		swap()

func pair():
	return
	
func swap():
	return
