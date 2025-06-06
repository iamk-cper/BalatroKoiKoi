extends Control
class_name CardSlotsTaken

@export var card_slot_scene: PackedScene = preload("res://scenes/CardSlot.tscn")
@export var card_scene:     PackedScene = preload("res://scenes/Card.tscn")
@onready var card_slots_hand: Node = get_tree().get_root().get_node("Game/CardManager/CardSlotsHand")
@onready var card_slots_table: Node = get_tree().get_root().get_node("Game/CardManager/CardSlotsTable")

const SLOT_SPACING: int = 350          # odstęp między slotami (w pikselach)
const DISPLAY_SCALE: float = 0.08      # współczynnik skalowania
@export var ROW_Y = 0
var hikari_cards: Array = []
var tane_cards: Array = []
var tanzaku_cards: Array = []
var kasu_cards: Array = []
var count = 4

@onready var _card_manager: CardManager = (
	get_tree().get_first_node_in_group("card_manager") as CardManager
)

func _ready() -> void:
	# Zapewnij, że ten Control ma rozmiar i jest widoczny
	visible = true
	#print("_ready CardSlotsTaken")
	#call_deferred("_populate_empty_slots")  # uzupełniamy, gdy talia będzie gotowa

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

	var index: int = group_node.get_child_count() - 1  # exclude TextureRect
	var start_x: float = 0.0
	var spacing_scaled: float = SLOT_SPACING * DISPLAY_SCALE

	var slot: Control = card_slot_scene.instantiate() as Control
	group_node.add_child(slot)

	# Positioning
	var y: float = texture_rect.position.y
	var base_w: float = (slot as CardSlot).card_base_size.x
	var scaled_w: float = base_w * DISPLAY_SCALE
	var x: float = start_x + index * (scaled_w + spacing_scaled)

	slot.position = Vector2(x, y)
	slot.scale = Vector2.ONE * DISPLAY_SCALE

	# Add card to slot
	card.get_parent().remove_child(card)
	slot.add_child(card)
	
	
	card.set_image_path()

	# Add to type-specific list
	match group_name:
		"Hikari":
			hikari_cards.append(card)
		"Tane":
			tane_cards.append(card)
		"Tanzaku":
			tanzaku_cards.append(card)
		"Kasu":
			kasu_cards.append(card)

	print("[DEBUG] Dodano kartę '%s' do grupy '%s' na pozycji (%.1f, %.1f)" % [card.card_info(), group_name, x, y])
