extends Control
class_name CardSlotsTaken

@export var card_slot_scene: PackedScene = preload("res://scenes/CardSlot.tscn")
@export var card_scene:     PackedScene = preload("res://scenes/Card.tscn")
@onready var card_slots_hand: Node = get_tree().get_root().get_node("Game/CardManager/CardSlotsHand")
@onready var card_slots_table: Node = get_tree().get_root().get_node("Game/CardManager/CardSlotsTable")

const SLOT_SPACING: int = 350          # odstęp między slotami (w pikselach)
const DISPLAY_SCALE: float = 0.08      # współczynnik skalowania
const MAX_GROUP_SPACE: int = 43
@export var ROW_Y = 0
var hikari_cards: Array = []
var tane_cards: Array = []
var tanzaku_cards: Array = []
var kasu_cards: Array = []
var count = 4

signal taken_changed(group_name: String, count: int)

func _ready() -> void:
	# Zapewnij, że ten Control ma rozmiar i jest widoczny
	visible = true
	#print("_ready CardSlotsTaken")
	#call_deferred("_populate_empty_slots")  # uzupełniamy, gdy talia będzie gotowa
	
func correct_positions(card_type: String):
	var card_groups = {
		"Hikari": hikari_cards,
		"Tane": tane_cards,
		"Tanzaku": tanzaku_cards,
		"Kasu": kasu_cards
	}

	var group: Array = card_groups.get(card_type, [])
	var group_size: int = group.size()
	print("group.size(): ", group.size())
	if group_size == 0:
		return

	var group_node: Node = get_node(card_type)
	var slots: Array = []
	for child in group_node.get_children():
		if child is CardSlot:
			slots.append(child)

	var start_x: float = 18.0

	print("slots.size(): ", slots.size())
	for i in range(slots.size()):
		var x: float
		var y: float = - i * 2.8
		if slots.size() == 1:
			x = start_x
		elif slots.size() < 6:
			x = start_x - MAX_GROUP_SPACE * float(i) / float(slots.size())
		elif slots.size() > 12:
			if i <= 12:
				x = start_x - MAX_GROUP_SPACE * float(i) / float(slots.size() - 1)
			else:
				x = start_x - MAX_GROUP_SPACE * 12.0 / float(slots.size() - 1)
				y = - 12 * 2.8
		else:
			x = start_x - MAX_GROUP_SPACE * float(i) / float(slots.size() - 1)

		slots[i].position = Vector2(x, y)

func add_card(card: Card) -> void:
	var group_name: String = card.card_type
	var group_node: Node = get_node_or_null(group_name)
	if group_node == null:
		push_warning("Nie znaleziono węzła grupy: %s" % group_node)
		return
	var texture_rect: TextureRect = group_node.get_node_or_null("TextureRect")
	if texture_rect == null:
		push_warning("Nie znaleziono TextureRect w %s" % group_node)
		return

	#var index: int = group_node.get_child_count() - 1  # exclude TextureRect
	#var spacing_scaled: float = SLOT_SPACING * DISPLAY_SCALE

	var slot: Control = card_slot_scene.instantiate() as Control
	group_node.add_child(slot)
	card.get_parent().remove_child(card)
	slot.add_child(card)
	card.set_image_path()
	card.deselect()

	# Add to type-specific list
	match group_name:
		"Hikari":
			hikari_cards.append(card)
			emit_signal("taken_changed", group_name, hikari_cards.size())
		"Tane":
			tane_cards.append(card)
			emit_signal("taken_changed", group_name, tane_cards.size())
		"Tanzaku":
			tanzaku_cards.append(card)
			emit_signal("taken_changed", group_name, tanzaku_cards.size())
		"Kasu":
			kasu_cards.append(card)
			emit_signal("taken_changed", group_name, kasu_cards.size())
	
	correct_positions(group_name)
	#print("[DEBUG] Dodano kartę '%s' do grupy '%s' na pozycji (%.1f, %.1f)" % [card.card_info(), group_name, x, y])
