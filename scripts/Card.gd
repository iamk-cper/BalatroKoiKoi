extends Control
class_name Card

# Eksportowane właściwości
var image_path: String = ""
var card_id: String = ""
var card_month: String = ""
var card_type: String = ""
var possible_selection: bool = true
var is_selected: bool = false

@onready var _tex_rect: TextureRect = $"CardImage"
@onready var _material: ShaderMaterial = null

func _ready() -> void:
	# Duplikuj materiał, aby każda karta miała własny egzemplarz
	if _tex_rect.material:
		_material = _tex_rect.material.duplicate(true)  # Głębokie kopiowanie
		_tex_rect.material = _material
		
		# Ustaw domyślną ramkę na białą i cienką
		_material.set("shader_parameter/border_color", Color(1.0, 1.0, 1.0, 1.0))  # Biały
		_material.set("shader_parameter/border_thickness", 30.0)  # Grubość
	else:
		push_error("Card.gd: Nie znaleziono materiału w CardImage")

	mouse_filter = MOUSE_FILTER_STOP
	focus_mode = FOCUS_ALL

func set_image_path() -> void:
	var tex := load(image_path)
	if tex:
		_tex_rect.texture = tex
		_tex_rect.size = tex.get_size()
		size = tex.get_size()

		# Przekazanie realnego rozmiaru tekstury do shader-a
		if _material:
			var tex_size = tex.get_size()
			_material.set("shader_parameter/texture_size", tex_size)
			print("[DEBUG] Rozmiar tekstury ustawiony na: ", tex_size)
	else:
		push_error("Card.gd: nie udało się wczytać tekstury %s" % image_path)

func card_info() -> String:
	return "Karta: " + card_id + " Miesiąc: " + card_month + " Typ: " + card_type + " Ścieżka obrazka: " + image_path

func select() -> void:
	is_selected = true
	if _material:
		_material.set("shader_parameter/border_color", Color(1.0, 0.0, 0.0, 1.0))  # Czerwony
	else:
		print("problem z shaderem czerwony")
	print("Karta zaznaczona: ", card_id, " (", card_month, " - ", card_type, ")")
	
func swap_selection() -> void:
	is_selected = false
	if _material:
		_material.set("shader_parameter/border_color", Color(1.0, 1.0, 0.0, 1.0))  # Żółty
	else:
		print("problem z shaderem zolty")
	print("Karta możliwa do swapa: ", card_id, " (", card_month, " - ", card_type, ")")


func deselect() -> void:
	is_selected = false
	if _material:
		_material.set("shader_parameter/border_color", Color(1.0, 1.0, 1.0, 1.0))  # Biały
	else:
		print("problem z shaderem bialy")
	print("Karta odznaczona: ", card_id, " (", card_month, " - ", card_type, ")")

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			var parent = get_parent().get_parent()
			print("[DEBUG] Kliknięto kartę: " + card_info())
			if parent and (parent.name == "CardSlotsHand" || parent.name == "CardSlotsTable"):
				print("Kliknięto kartę: ", card_info())
				parent.toggle_card_selection(self)
