extends Control

@export var card_slot_scene: PackedScene = preload("res://scenes/CardSlot.tscn")
@export var card_scene:     PackedScene = preload("res://scenes/Card.tscn")

@export const SLOT_SPACING: int = 350          # odstęp między slotami (w pikselach)
@export const DISPLAY_SCALE: float = 0.08      # współczynnik skalowania
@export var ROW_Y = 0
const COUNT: int = 4

@onready var _card_manager: CardManager = (
	get_tree().get_first_node_in_group("card_manager") as CardManager
)

func _ready() -> void:
	# Zapewnij, że ten Control ma rozmiar i jest widoczny
	visible = true

	generate_card_slots()
	call_deferred("_populate_empty_slots")  # uzupełniamy, gdy talia będzie gotowa

func generate_card_slots() -> void:
	
	for child in get_children():
		child.queue_free()

	if card_slot_scene == null:
		push_error("CARD_SLOT_SCENE == null – nie załadowano sceny CardSlot.tscn")
		return

	var start_x: float = 1030
	var spacing_scaled: float = SLOT_SPACING * DISPLAY_SCALE

	for i in range(COUNT):
		
		var slot: Control = card_slot_scene.instantiate() as Control
		add_child(slot)
		var base_w: float = (slot as CardSlot).card_base_size.x
		var scaled_w := base_w * DISPLAY_SCALE

		
		if i < 2:
			ROW_Y = 210
			slot.position = Vector2(start_x + i * (scaled_w + spacing_scaled), ROW_Y)
		else:
			ROW_Y = 50
			slot.position = Vector2(start_x + (i - 2) * (scaled_w + spacing_scaled), ROW_Y)
			
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
