extends Label
##
##  Wyświetla liczbę kart pozostałych w talii.
##

@onready var _card_manager: CardManager = get_tree().get_root().get_node("Main/Game/CardManager")

func _ready() -> void:
	text = "See all cards..."
