extends Control

@onready var switch_button = $Button
@onready var mode_button: Node = get_tree().get_root().get_node("Main/Game/GUI/ModeButton")
@onready var card_slots_hand: Node = get_tree().get_root().get_node("Main/Game/CardManager/CardSlotsHand")
@onready var card_slots_table: Node = get_tree().get_root().get_node("Main/Game/CardManager/CardSlotsTable")
@onready var card_slots_taken: Node = get_tree().get_root().get_node("Main/Game/CardManager/CardSlotsTaken")
@onready var card_slots_deck: Node = get_tree().get_root().get_node("Main/Game/CardManager/CardSlotsDeck")
@onready var _card_manager: CardManager = get_tree().get_root().get_node("Main/Game/CardManager")

func _ready():
	# Przypisanie sygnału do przycisku
	switch_button.pressed.connect(_on_button_pressed)

# Funkcja zmiany widoczności
func _on_button_pressed():
	if card_slots_deck.is_selected == true && card_slots_table.selected_cards.size() == 1:
		pair_with_deck(_card_manager.draw_card(), card_slots_table.selected_cards[0])
	elif mode_button.pair_state == true && card_slots_hand.selected_cards.size() == 1 && card_slots_table.selected_cards.size() == 1:
		pair(card_slots_hand.selected_cards[0], card_slots_table.selected_cards[0])
	elif mode_button.pair_state == false && card_slots_hand.selected_cards.size() > 0:
		swap()

func pair(card1: Card, card2: Card):
	card_slots_taken.add_card(card1)
	card_slots_taken.add_card(card2)
	card_slots_hand.clear_selection()
	card_slots_table.clear_selection()
	card_slots_table.populated_counter -= 1
	card_slots_hand.populated_counter -= 1
	var card: Card = _card_manager.get_top_card()
	if card != null:
		print("Current top card is: %s", card.card_info())
		var pair_possibility: bool = false
		for c in card_slots_table.get_cards():
			#print("Card in card_slots_table is: ", c.card_info())
			if card.card_month == c.card_month:
				pair_possibility = true
		if pair_possibility == false:
			print("Okej dodamy 1!")
			card_slots_table._populate_empty_slots(1)
		else:
			card_slots_deck.is_selected = true
			_card_manager.swap_possibilities(card)
			card_slots_deck.add_child(card)
			card.position += Vector2(18, 0)
			card.set_image_path()
			card.select()
	
	if card_slots_table.get_cards().is_empty():
		print("You have no more cards on the table...")
		_card_manager.finish_game()
	elif card_slots_hand.get_cards().is_empty():
		print("You have no more cards on the table...")
		_card_manager.finish_game()
	elif _card_manager.deck.is_empty():
		print("You paired, deck is empty")
		if !_card_manager.is_pairing_possible():
			print("You have no more pairing possibilities...")
			_card_manager.finish_game()
	else:
		print("Card_slots_table.get_cards().size(): ", card_slots_table.get_cards().size())
		print("Card_slots_hand.get_cards().size():", card_slots_hand.get_cards().size())
			
func pair_with_deck(card1: Card, card2: Card):
	card_slots_deck.is_selected = false
	card1.position += Vector2(-18, 0)
	card_slots_taken.add_card(card1)
	card_slots_taken.add_card(card2)
	card_slots_hand.clear_selection()
	card_slots_table.clear_selection()
	card_slots_table.populated_counter -= 1
	#print("Current top card is: %s", _card_manager.get_top_card().card_info())
	if card_slots_table.get_cards().is_empty():
		print("You have no more cards on the table...")
		_card_manager.finish_game()
	elif card_slots_hand.get_cards().is_empty():
		print("You have no more cards on the table...")
		_card_manager.finish_game()
	elif _card_manager.deck.is_empty():
		print("You paired with deck, now deck is empty")
		if !_card_manager.is_pairing_possible():
			print("You have no more pairing possibilities...")
			_card_manager.finish_game()
	
func swap():
	var selected_counter: int = card_slots_hand.selected_cards.size()
	card_slots_hand.populated_counter -= selected_counter
	for card in card_slots_hand.selected_cards:
		card.get_parent().remove_child(card)
		_card_manager.lost_cards.append(card)
		
	card_slots_hand.clear_selection() 
	card_slots_hand._populate_empty_slots(selected_counter)
	
	if card_slots_hand.get_cards().is_empty():
		print("You have no more cards on in the hand...")
		_card_manager.finish_game()
	elif _card_manager.deck.is_empty():
		print("You swapped, deck is empty")
		if !_card_manager.is_pairing_possible():
			print("You have no more pairing possibilities...")
			_card_manager.finish_game()
	
#func pair_card_selection(card: Node) -> void:
	#if card in selected_cards:
		#selected_number -= 1
		#selected_cards.erase(card)
		#
		#if card_slots_hand.selected_cards.size() == 1: #
			#if card.card_month == _card_manager.get_top_card().card_month:
				#card.swap_selection()
			#else:
				#card.deselect()
		#else:
			#card.deselect()
		#
	#elif selected_number < selection_limit && card.card_month == _card_manager.get_top_card().card_month:
		#selected_number += 1
		#selected_cards.append(card)
		#card.select()
