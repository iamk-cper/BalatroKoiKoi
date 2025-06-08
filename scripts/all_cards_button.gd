extends Button

@export var all_cards_scene: PackedScene = preload("res://scenes/all_cards.tscn")

func _pressed() -> void:
	var game_root := get_tree().get_root().get_node("Main/Game")
	if game_root and all_cards_scene:
		var all_cards_view = all_cards_scene.instantiate()
		game_root.add_child(all_cards_view)
