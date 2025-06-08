extends Label
##
##  Wyświetla liczbę kart pozostałych w talii.
##

@onready var _card_manager: CardManager = (
	get_tree().get_first_node_in_group("card_manager") as CardManager
)

func _ready() -> void:
	text = "See all cards..."
