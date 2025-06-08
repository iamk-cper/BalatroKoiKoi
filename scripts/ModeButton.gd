extends Control

#@export var card_slots_hand: PackedScene     = preload("res://scenes/CardSlotsHand.tscn")

# Węzły typu TextureRect
@onready var texture1 = $SwapButton
@onready var texture2 = $PairButton
@onready var switch_button = $Button
@onready var card_slots_table: Node = get_tree().get_root().get_node("Game/CardManager/CardSlotsTable")
@onready var card_slots_hand: Node = get_tree().get_root().get_node("Game/CardManager/CardSlotsHand")
@onready var card_slots_deck: Node = get_tree().get_root().get_node("Game/CardManager/CardSlotsDeck")
@onready var _card_manager: CardManager = (
	get_tree().get_first_node_in_group("card_manager") as CardManager
)


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
	_update_visibility()
	if pair_state == true && card_slots_deck.is_selected == false:
		card_slots_table.clear_selection()
	elif card_slots_hand.selected_cards.size() == 1:
		_card_manager.swap_possibilities(card_slots_hand.selected_cards[0])
		print("[DEBUG] Number of cards selected: %s" % card_slots_hand.selected_cards.size())
	else:
		print("[DEBUG] Number of cards selected: %s" % card_slots_hand.selected_cards.size())
	pair_state = !pair_state

# Aktualizacja widoczności obu TextureRect
func _update_visibility():
	is_texture1_visible = !is_texture1_visible
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
