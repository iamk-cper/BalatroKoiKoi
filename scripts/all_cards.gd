extends Control

@export var bigger_button_scene: PackedScene = preload("res://scenes/bigger_button.tscn")

const SCALE := 0.08
const CARD_BASE_SIZE := Vector2(976, 1600)
const CARD_SIZE := CARD_BASE_SIZE * SCALE
const CARDS_PER_MONTH := 4
const MONTHS_PER_ROW := 6

const TOTAL_ROWS := 2
const TOTAL_COLUMNS := 6

const CARD_GAP := Vector2(5,5)       # Odstępy między kartami w 2x2
const MONTH_GAP := Vector2(30,30)    # Odstępy między blokami miesięcy

@onready var card_slots_taken: CardSlotsTaken = get_tree().get_root().get_node("Main/Game/CardManager/CardSlotsTaken")
@onready var _card_manager: CardManager = get_tree().get_root().get_node("Main/Game/CardManager")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		queue_free()
		
func _ready():
	_create_overlay()
	_add_close_button()
	_generate_all_cards()

func _create_overlay():
	var overlay := ColorRect.new()
	overlay.name = "Overlay"
	overlay.color = Color(0, 0, 0, 0.95)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.focus_mode = Control.FOCUS_ALL


	# Offsets (muszą być zerowe dla pełnego rozciągnięcia)
	overlay.offset_left = 0.0
	overlay.offset_top = 0.0
	overlay.offset_right = 0.0
	overlay.offset_bottom = 0.0

	# Wymuś minimalny rozmiar (niezbędne bez kontenera)
	overlay.size = get_viewport_rect().size

	add_child(overlay)

func _add_close_button():
	var screen_size = get_viewport_rect().size
	var button_size = Vector2(231, 111)  # Rozmiar zgodny z bigger_button.tscn

	var close_button: Control = bigger_button_scene.instantiate()
	close_button.name = "CloseButton"
	close_button.get_node("Button").text = "Close"
	close_button.get_node("Button").pressed.connect(func(): queue_free())

	# Wyśrodkuj na dole
	var x = (screen_size.x - button_size.x) / 2
	var y = screen_size.y - button_size.y
	close_button.position = Vector2(x, y)

	add_child(close_button)

func _generate_all_cards():
	var card_data := {
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

	var months := card_data.keys()
	var base_path := "res://assets/cards/"

	var month_block_size := Vector2(
		CARD_SIZE.x * 2 + CARD_GAP.x,
		CARD_SIZE.y * 2 + CARD_GAP.y
	)
	var grid_size := Vector2(
		TOTAL_COLUMNS * month_block_size.x + (TOTAL_COLUMNS - 1) * MONTH_GAP.x,
		TOTAL_ROWS * month_block_size.y + (TOTAL_ROWS - 1) * MONTH_GAP.y
	)
	var screen_size := Vector2(1280, 720)
	var grid_origin := (screen_size - grid_size) / 2  # Wyśrodkowanie
	
	for month_index in range(months.size()):
		var month: String = months[month_index]
		var types: Array = card_data[month]

		var grid_col := month_index % MONTHS_PER_ROW
		var grid_row := month_index / MONTHS_PER_ROW
		
		var block_origin := grid_origin + Vector2(
			grid_col * (month_block_size.x + MONTH_GAP.x),
			grid_row * (month_block_size.y + MONTH_GAP.y) - 30
		)
		
		for i in range(CARDS_PER_MONTH):
			var tex := TextureRect.new()
			var type: String = types[i]
			var number := i + 1
			var id := "%s_%s_%d" % [month, type, number]
			var path := "%sHanafuda %s %s %d.svg" % [base_path, month, type, number]

			tex.texture = load(path)
			tex.scale = Vector2(SCALE, SCALE)
			tex.stretch_mode = TextureRect.STRETCH_KEEP  # użyj KEEP dla ręcznego skalowania

			_is_card_taken(id, tex)

			var local_x := (i % 2) * (CARD_SIZE.x + CARD_GAP.x)  # base width before scale
			var local_y := (i / 2) * (CARD_SIZE.y + CARD_GAP.y)  # base height before scale
			tex.position = block_origin + Vector2(local_x, local_y)
			print("Card position: ", tex.position.x, " ", tex.position.y)
			add_child(tex)

func _is_card_taken(card_id: String, tex: TextureRect) -> void:
	for group in [card_slots_taken.hikari_cards, card_slots_taken.tane_cards, card_slots_taken.tanzaku_cards, card_slots_taken.kasu_cards]:
		for card in group:
			if card.card_id == card_id:
				return
	for card in _card_manager.lost_cards:
		if card.card_id == card_id:
			tex.modulate = Color(0.10, 0.10, 0.10, 1)
			return
	tex.modulate = Color(0.58, 0.58, 0.58, 1)
