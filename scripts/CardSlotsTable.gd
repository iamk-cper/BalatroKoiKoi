extends Control

@export var card_slot_scene: PackedScene = preload("res://scenes/CardSlot.tscn")
@export var card_scene:     PackedScene = preload("res://scenes/Card.tscn")

var selected_cards: Array = []
var selected_number: int = 0
var selection_limit: int = 1

const SLOT_SPACING: int = 120          # odstęp między slotami (w pikselach)
const DISPLAY_SCALE: float = 0.08      # współczynnik skalowania
var ROW_Y = 0

@onready var _card_manager: CardManager = (
	get_tree().get_first_node_in_group("card_manager") as CardManager
)

func _ready() -> void:
	# Zapewnij, że ten Control ma rozmiar i jest widoczny
	visible = true

	generate_card_slots()
	call_deferred("_populate_empty_slots")  # uzupełniamy, gdy talia będzie gotowa

func toggle_card_selection(card: Node) -> void:
	if card in selected_cards:
		selected_number -= 1
		selected_cards.erase(card)
		card.deselect() # Funkcja odznaczenia w skrypcie Card
		print("[DEBUG] Karta odznaczona w CardSlotsHand: ", card.card_id)
	elif selected_number < selection_limit:
		selected_number += 1
		selected_cards.append(card)
		card.select() # Funkcja zaznaczenia w skrypcie Card
		print("[DEBUG] Karta zaznaczona w CardSlotsHand: ", card.card_id)
	
	print("[DEBUG] Aktualna liczba zaznaczonych kart: ", selected_cards.size())
	print("[DEBUG] Lista zaznaczonych kart: ", get_selected_cards_ids())
	
func get_selected_cards_ids() -> Array:
	var ids = []
	for card in selected_cards:
		ids.append(card.card_id)
	return ids
	
		# Wyczyszczenie wszystkich zaznaczeń
func clear_selection() -> void:
	for card in selected_cards:
		card.deselect()
	selected_number = 0
	selected_cards.clear()

# Pobranie wszystkich zaznaczonych kart
func get_selected_cards() -> Array:
	return selected_cards

func generate_card_slots() -> void:
	
	for child in get_children():
		child.queue_free()

	if card_slot_scene == null:
		push_error("CARD_SLOT_SCENE == null – nie załadowano sceny CardSlot.tscn")
		return

	var start_x: float = 490
	var spacing_scaled: float = SLOT_SPACING * DISPLAY_SCALE

	for i in range(10):
		
		var slot: Control = card_slot_scene.instantiate() as Control
		add_child(slot)
		var base_w: float = (slot as CardSlot).card_base_size.x
		var scaled_w := base_w * DISPLAY_SCALE

		
		if i < 4:
			ROW_Y = 350
			slot.position = Vector2(start_x + i * (scaled_w + spacing_scaled), ROW_Y)
		elif i < 8:	
			ROW_Y = 210
			slot.position = Vector2(start_x + (i - 4) * (scaled_w + spacing_scaled), ROW_Y)
		elif i == 9:
			ROW_Y = 350
			slot.position = Vector2(start_x + 4 * (scaled_w + spacing_scaled), ROW_Y)
		else:
			ROW_Y = 210
			slot.position = Vector2(start_x + 4 * (scaled_w + spacing_scaled), ROW_Y)
			
		#print("  Slot ", i + 1, ":")
		#print("  Pozycja slotu: ", slot.position)
		#print("  TextureRect base size: ", base_size)
		#print("  TextureRect scaled size: ", scaled_size)
		#print("  Slot size: ", slot.size)

func _populate_empty_slots() -> void:
	if _card_manager == null:
		push_error("CardSlotsHand: CardManager NOT found")
		return

	for slot in get_children():
		# pomijamy sloty, które już mają kartę
		if slot.find_child("Card", true, false) != null:
			continue

		var card: Card = _card_manager.draw_card()
		#print(card.print_card_info())
		if card == null:
			push_warning("CardSlotsHand: Deck empty – no card drawn")
			continue

		slot.add_child(card)
		card.set_image_path()

		print("[DEBUG] Added card '%s' to slot '%s'" % [card.card_info(), slot.name])
