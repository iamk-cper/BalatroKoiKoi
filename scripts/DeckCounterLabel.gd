extends Label
##
##  Wyświetla liczbę kart pozostałych w talii.
##

@onready var _card_manager: CardManager = get_tree().get_root().get_node("Main/Game/CardManager")

func _ready() -> void:
	if _card_manager:
		_card_manager.deck_changed.connect(_on_deck_changed)
		_on_deck_changed(_card_manager.deck.size())   # ustaw początkowy tekst
	else:
		text = "Talia: ?"

func _on_deck_changed(remaining: int) -> void:
	text = "Talia: %d" % remaining
