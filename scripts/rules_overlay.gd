extends Control

@export var button_scene: PackedScene = preload("res://scenes/bigger_button.tscn")

const SCALE := 0.08
const CARD_BASE_SIZE := Vector2(976, 1600)
const CARD_SIZE := CARD_BASE_SIZE * SCALE
const CARDS_PER_MONTH := 4
const MONTHS_PER_ROW := 6
const TOTAL_ROWS := 2
const TOTAL_COLUMNS := 6

const CARD_GAP := Vector2(5,5)
const MONTH_GAP := Vector2(30,30)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		queue_free()

func _ready():
	_create_overlay()
	_generate_all_cards()
	_add_rules_text()
	_add_back_button()

func _create_overlay():
	var overlay := ColorRect.new()
	overlay.name = "Overlay"
	overlay.color = Color(0, 0, 0, 0.85)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.focus_mode = Control.FOCUS_ALL
	overlay.offset_left = 0.0
	overlay.offset_top = 0.0
	overlay.offset_right = 0.0
	overlay.offset_bottom = 0.0
	overlay.size = get_viewport_rect().size
	add_child(overlay)

func _generate_all_cards():
	# ... jak u Ciebie, bez zmian ...
	pass  # ← pomiń, jeśli chcesz tylko teksty zasad – albo skopiuj całość ze swojej wersji

func _add_rules_text():
	var screen_size = get_viewport_rect().size
	var margin = 60
	var button_height = 111
	var spacing = 20  # odstęp między tekstem a przyciskiem

	var text_area_height = screen_size.y - button_height - spacing - 40  # 40px offset od góry
	var text_area_size = Vector2(screen_size.x - margin * 2, text_area_height)

	# Scrollable container
	var scroll := ScrollContainer.new()
	scroll.position = Vector2(margin, 40)
	scroll.size = text_area_size
	scroll.name = "RulesScroll"
	scroll.mouse_filter = Control.MOUSE_FILTER_PASS

	# Label inside scroll
	var rule_label := Label.new()
	rule_label.text = """Game version: v0.1.0 — Current Rules

Game UI:
- On the left, you see currently unavailable functions, followed by the deck card (if it can be paired) and the number of cards remaining in the deck.
- In the center, you see table cards. At the bottom, there are hand cards, the PAIR/SWAP buttons, and the ACCEPT button.
- On the right, you see the collected (paired) cards and the "See all cards..." button, which shows all discarded and taken cards.

Rule 1: In pair mode, you can select one card from your hand to view matching table cards. Click a matching table card and press ACCEPT to confirm the pair.
Rule 2: The table is then updated with the next card from the deck, if available. If that deck card can be paired, it will be shown and you must select a table card to match it.
Rule 3: In swap mode, you can discard up to 4 hand cards and draw the same number of new cards from the deck.
Rule 4: At the end of the game, points are calculated based on standard Koi-Koi yaku combinations.
"""

	rule_label.label_settings = LabelSettings.new()
	rule_label.label_settings.font_size = 18
	rule_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	rule_label.custom_minimum_size = Vector2(text_area_size.x, 0)
	rule_label.size_flags_vertical = Control.SIZE_EXPAND

	scroll.add_child(rule_label)
	add_child(scroll)



func _add_back_button():
	var screen_size = get_viewport_rect().size
	var button_size = Vector2(231, 111)  # ustalone na podstawie bigger_button.tscn

	var back_button := button_scene.instantiate()
	back_button.name = "BackButton"
	back_button.get_node("Button").text = "Back to menu"
	back_button.get_node("Button").pressed.connect(func(): queue_free())

	# Wyśrodkowany poziomo, umieszczony 111px nad dolną krawędzią
	var x = (screen_size.x - button_size.x) / 2
	var y = screen_size.y - button_size.y

	back_button.position = Vector2(x, y)
	add_child(back_button)
