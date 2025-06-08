extends Control
class_name CardManager

@export var bigger_button_scene: PackedScene = preload("res://scenes/bigger_button.tscn")

@export var card_scene:     PackedScene = preload("res://scenes/Card.tscn")

@onready var card_slots_hand: Node = get_tree().get_root().get_node("Game/CardManager/CardSlotsHand")
@onready var card_slots_table: Node = get_tree().get_root().get_node("Game/CardManager/CardSlotsTable")
@onready var card_slots_taken: Node = get_tree().get_root().get_node("Game/CardManager/CardSlotsTaken")

signal deck_changed(remaining: int)

## Karty jeszcze w talii
var deck: Array[Card] = []

## Karty już wykorzystane
var discarded: Array[Card] = []
var lost_cards: Array = []

const MONTHS: PackedStringArray = [
	"January", "February", "March", "April", "May", "June",
	"July", "August", "September", "October", "November", "December"
]

const TYPES: PackedStringArray = [
	"Hikari", "Kasu", "Tanzaku", "Tane"
]

func swap_possibilities(card: Card) -> void:
	for slot in card_slots_table.get_children():
		var possible_card = slot.get_node_or_null("Card")
		if possible_card == null:
			continue
		if possible_card.card_month == card.card_month:
			possible_card.swap_selection()

func swap_possibilities_clear() -> void:
	for slot in card_slots_table.get_children():
		var possible_card = slot.get_node_or_null("Card")
		print("[DEBUG] swap_possibilities_clear() possible_card value: %s", possible_card)
		if possible_card != null:
			possible_card.deselect()
			#if possible_card in card_slots_table.selected_cards:
				#card_slots_table.selected_cards.erase(possible_card)

func _enter_tree() -> void:
	add_to_group("card_manager")
	_build_deck()
	_shuffle_deck()
	emit_signal("deck_changed", deck.size())
	

# -------------------------------------------------------------------
# API
# -------------------------------------------------------------------

func finish_game() -> void:
	print("Game finished, calculating points!")

	# Oblicz punkty
	var points := calculate_points()
	var total_points: int = points.total

	# Overlay
	var overlay := ColorRect.new()
	overlay.name = "EndGameOverlay"
	overlay.color = Color(0, 0, 0, 0.85)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.focus_mode = Control.FOCUS_ALL

	# Offsets: zero by wypełnić cały ekran
	overlay.offset_left = 0.0
	overlay.offset_top = 0.0
	overlay.offset_right = 0.0
	overlay.offset_bottom = 0.0

	# Wymuszenie rozmiaru (nie ma kontenera)
	overlay.size = get_viewport_rect().size

	add_child(overlay)

	# Tekst z punktami
	var label := Label.new()
	label.name = "PointsLabel"
	label.text = "Points: %d\n_____________\nKasu: %d\nHikari: %d\nTane: %d\nTanzaku: %d" % [
		total_points,
		points.kasu,
		points.hikari,
		points.tane,
		points.tanzaku
	]
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = 32
	label.modulate = Color(1, 1, 1)
	label.anchor_left = 0.5
	label.anchor_top = 0.5
	label.anchor_right = 0.5
	label.anchor_bottom = 0.5
	label.offset_left = -200
	label.offset_top = -150
	label.offset_right = 200
	label.offset_bottom = 150
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	overlay.add_child(label)
	
	# Przyciski - instancje
	var play_again_button: Control = bigger_button_scene.instantiate()
	var close_button: Control = bigger_button_scene.instantiate()

	# Konfiguracja przycisków
	play_again_button.name = "PlayAgainButton"
	play_again_button.get_node("Button").text = "Play again"
	play_again_button.get_node("Button").pressed.connect(new_game)

	close_button.name = "CloseButton"
	close_button.get_node("Button").text = "Close"
	close_button.get_node("Button").pressed.connect(close)

	# Ustawienia pozycji i rozmiaru z marginesem 10px
	var screen_size = get_viewport_rect().size
	var button_size = Vector2(231, 111)

	var total_width = button_size.x * 2
	var start_x = (screen_size.x - total_width) / 2
	var y = screen_size.y - button_size.y  # 30px od dolnej krawędzi

	# Pozycje z marginesem
	play_again_button.position = Vector2(start_x, y)
	close_button.position = Vector2(start_x + button_size.x, y)

	# Dodaj przyciski do overlaya
	overlay.add_child(play_again_button)
	overlay.add_child(close_button)

func close() -> void:
	print("Closing the game...")
	get_tree().quit()

func new_game() -> void:
	print("Starting a new game...")
	get_tree().reload_current_scene()


func calculate_points() -> Dictionary:
	var hikari: int = card_slots_taken.hikari_cards.size()
	var tane: int = card_slots_taken.tane_cards.size()
	var tanzaku: int = card_slots_taken.tanzaku_cards.size()
	var kasu: int = card_slots_taken.kasu_cards.size()
	var hikari_points: int = 0
	var tane_points: int = 0
	var tanzaku_points: int = 0
	var kasu_points: int = 0
	
	if hikari == 5:
		#gokou
		hikari_points += 10
	elif hikari == 4:
		var isRainMan = false
		for hikari_card in card_slots_taken.hikari_cards:
			if hikari_card.card_month == "November" && hikari_card.card_type == "Hikari":
				isRainMan = true
		if isRainMan:
			#ame-shikou
			hikari_points += 7
		else:
			#shikou
			hikari_points += 8
	elif hikari == 3:
		#sankou
		var isRainMan = false
		for hikari_card in card_slots_taken.hikari_cards:
			if hikari_card.card_month == "November" && hikari_card.card_type == "Hikari":
				isRainMan = true
		if !isRainMan:
			hikari_points += 5
			
	if tane >= 3:
		if tane == 3:
			tane_points += 2
		else:
			tane_points += tane
		#inoshikachou
		var inoshikachou_counter: int = 0
		for tane_card in card_slots_taken.tane_cards:
			if tane_card.card_month == "July":
				inoshikachou_counter += 1
			elif tane_card.card_month == "October":
				inoshikachou_counter += 1
			elif tane_card.card_month == "June":
				inoshikachou_counter += 1
		if inoshikachou_counter == 3:
			tane_points += 5
	
	for tane_card in card_slots_taken.tane_cards:
		if tane_card.card_month == "September":
			for hikari_card in card_slots_taken.hikari_cards:
				#moon viewing
				if hikari_card.card_month == "August":
					hikari_points += 5
				#cherry blossom viewing
				elif hikari_card.card_month == "March":
					hikari_points += 5
					
	if kasu >= 10:
		kasu_points += kasu - 9
		
	if tanzaku >= 3:
		if tanzaku >= 5:
			tanzaku_points += tanzaku - 4
		
		#red poetry tanzaku
		#blue tanzaku
		var red_poetry_counter: int = 0
		var blue_tanzaku_counter: int = 0
		for tanzaku_card in card_slots_taken.tanzaku_cards:
			if tanzaku_card.card_month == "June" || tanzaku_card.card_month == "September" || tanzaku_card.card_month == "October":
				blue_tanzaku_counter += 1
			elif tanzaku_card.card_month == "January" || tanzaku_card.card_month == "February" || tanzaku_card.card_month == "March":
				red_poetry_counter += 1
		if blue_tanzaku_counter == 3:
			tanzaku_points += 5
		if red_poetry_counter == 3:
			tanzaku_points += 5
		
	return {
		"total": kasu_points + hikari_points + tane_points + tanzaku_points,
		"hikari": hikari_points,
		"tane": tane_points,
		"tanzaku": tanzaku_points,
		"kasu": kasu_points
	}

func is_pairing_possible() -> bool:
	for hand_slot in card_slots_hand.get_children():
		var hand_card: Card = hand_slot.get_node_or_null("Card")
		if hand_card == null:
			continue
		for table_slot in card_slots_table.get_children():
			var table_card: Card = table_slot.get_node_or_null("Card")
			if table_card == null:
				continue
			if table_card.card_month == hand_card.card_month:
				return true
	return false

func get_top_card() -> Card:
	if deck.is_empty():
		return null
	else:
		var card: Card = deck.back()
		return card

func draw_card() -> Card:
	if deck.is_empty():
		return null
	else:
		var card: Card = deck.pop_back()   #  <-- jawny typ String
		discarded.append(card)
		emit_signal("deck_changed", deck.size())
		return card

func reset_deck() -> void:
	_build_deck()
	discarded.clear()
	_shuffle_deck()
	emit_signal("deck_changed", deck.size())

# -------------------------------------------------------------------
# INTERNAL
# -------------------------------------------------------------------

func _build_deck() -> void:
	var card_data = {
		"January": ["Kasu", "Kasu", "Tanzaku", "Hikari"],
		"February": ["Kasu", "Kasu", "Tanzaku", "Tane"],
		"March": ["Kasu", "Kasu", "Tanzaku", "Hikari"],
		"April": ["Kasu", "Kasu", "Tanzaku", "Tane"],
		"May": ["Kasu", "Kasu", "Tanzaku", "Tane"],
		"June": ["Kasu", "Kasu", "Tanzaku", "Tane"],
		"July": ["Kasu", "Kasu", "Tanzaku", "Tane"],
		"August": ["Kasu", "Kasu", "Tane", "Hikari"],
		"September": ["Kasu", "Kasu", "Tanzaku", "Tane"],
		"October": ["Kasu", "Kasu", "Tanzaku", "Tane"],
		"November": ["Kasu", "Tanzaku", "Tane", "Hikari"],
		"December": ["Kasu", "Kasu", "Kasu", "Hikari"]
	}
	
	var image_base_path = "res://assets/cards/"
	
	deck.clear()
	for month in MONTHS:
		var card_types = card_data[month]
		for i in range(card_types.size()):
			var card = card_scene.instantiate()
			card.card_month = month
			card.card_type = card_types[i]
			card.card_id = month + "_" + card_types[i] + "_" + str(i + 1)
			#print("[DEBUG] month %s, card_types %s, num %s" % [month, card_types[i], str(i+1)])
			card.image_path = image_base_path + "Hanafuda %s %s %s.svg" % [month, card_types[i], str(i+1)]
			deck.append(card)

func _shuffle_deck() -> void:
	deck.shuffle()
