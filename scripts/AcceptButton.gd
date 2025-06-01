extends Control

@onready var switch_button = $Button
@onready var mode_button: Node = get_tree().get_root().get_node("Game/GUI/ModeButton")
@onready var card_slots_hand: Node = get_tree().get_root().get_node("Game/CardManager/CardSlotsHand")
@onready var card_slots_table: Node = get_tree().get_root().get_node("Game/CardManager/CardSlotsTable")

func _ready():
	# Przypisanie sygnału do przycisku
	switch_button.pressed.connect(_on_button_pressed)

# Funkcja zmiany widoczności
func _on_button_pressed():
	if mode_button.pair_state == true && card_slots_hand.selected_cards.size() == 1 && card_slots_table.selected_cards.size() == 1:
		pair()
	elif mode_button.pair_state == false && card_slots_hand.selected_cards.size() > 0:
		swap()

func pair():
	return
	
func swap():
	var selected_counter: int = card_slots_hand.selected_cards.size()
	card_slots_hand.populated_counter -= selected_counter
	for card in card_slots_hand.selected_cards:
		card.get_parent().remove_child(card)
		card.queue_free()
		
	card_slots_hand.clear_selection() 
	card_slots_hand._populate_empty_slots(selected_counter)
