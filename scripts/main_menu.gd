extends Control

signal start_game
signal show_rules
signal exit_game

@export var button_scene: PackedScene = preload("res://scenes/bigger_button.tscn")

func _ready():
	var screen_size = get_viewport_rect().size
	var button_size = Vector2(231,111)
	var spacing = -30

	# Teksty i sygnały do przypisania
	var buttons_data = [
		{"text": "Start game", "callback": func(): emit_signal("start_game")},
		{"text": "Rules", "callback": func(): emit_signal("show_rules")},
		{"text": "Exit", "callback": func(): emit_signal("exit_game")}
	]

	var total_height = buttons_data.size() * button_size.y + (buttons_data.size() - 1) * spacing
	var start_y = (screen_size.y - total_height) / 2

	for i in buttons_data.size():
		var btn_data = buttons_data[i]
		var btn = button_scene.instantiate()
		var y = start_y + i * (button_size.y + spacing)
		btn.position = Vector2((screen_size.x - button_size.x) / 2, y)
		btn.get_node("Button").text = btn_data["text"]
		btn.get_node("Button").pressed.connect(btn_data["callback"])
		add_child(btn)
