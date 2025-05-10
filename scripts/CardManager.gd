extends Node
class_name CardManager

@export var card_scene:     PackedScene = preload("res://scenes/Card.tscn")

signal deck_changed(remaining: int)



## Karty jeszcze w talii
var deck: Array[Card] = []

## Karty już wykorzystane
var discarded: Array[Card] = []

const MONTHS: PackedStringArray = [
	"January", "February", "March", "April", "May", "June",
	"July", "August", "September", "October", "November", "December"
]

const TYPES: PackedStringArray = [
	"Hikari", "Kasu", "Tanzaku", "Tane"
]

func _enter_tree() -> void:
	add_to_group("card_manager")
	_build_deck()
	_shuffle_deck()
	emit_signal("deck_changed", deck.size())
	

# -------------------------------------------------------------------
# API
# -------------------------------------------------------------------

func draw_card() -> Card:
	if deck.is_empty():
		if discarded.is_empty():
			return null  # talia definitywnie pusta
		deck = discarded.duplicate()
		discarded.clear()
		_shuffle_deck()

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
