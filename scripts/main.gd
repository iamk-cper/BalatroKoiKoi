extends Control

@onready var current_scene: Node = null

var game_scene := preload("res://scenes/Game.tscn")
var menu_scene := preload("res://scenes/MainMenu.tscn")

func _ready():
	load_menu()

func load_menu():
	if current_scene:
		current_scene.queue_free()
	current_scene = menu_scene.instantiate()
	add_child(current_scene)
	current_scene.connect("start_game", Callable(self, "start_game"))
	current_scene.connect("show_rules", Callable(self, "show_rules"))
	current_scene.connect("exit_game", Callable(self, "exit_game"))

func start_game():
	if current_scene:
		current_scene.queue_free()
		
	await get_tree().process_frame
	current_scene = game_scene.instantiate()
	add_child(current_scene)

func show_rules():
	var overlay := preload("res://scenes/RulesOverlay.tscn").instantiate()
	add_child(overlay)

func exit_game():
	get_tree().quit()
