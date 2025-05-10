extends Control

# Węzły typu TextureRect
@onready var texture1 = $SwapButton
@onready var texture2 = $PairButton
@onready var switch_button = $Button

# Aktualny stan widoczności
var is_texture1_visible: bool = true

func _ready():
	# Przypisanie sygnału do przycisku
	switch_button.pressed.connect(_on_button_pressed)

	# Ustawienie początkowej widoczności
	_update_visibility()

# Funkcja zmiany widoczności
func _on_button_pressed():
	# Przełączenie stanu widoczności
	is_texture1_visible = !is_texture1_visible
	_update_visibility()

# Aktualizacja widoczności obu TextureRect
func _update_visibility():
	if is_texture1_visible:
		texture1.visible = true
		texture1.modulate.a = 1.0  # 100% widoczność
		texture2.visible = false
		texture2.modulate.a = 0.0  # 0% widoczność
	else:
		texture1.visible = false
		texture1.modulate.a = 0.0  # 0% widoczność
		texture2.visible = true
		texture2.modulate.a = 1.0  # 100% widoczność
