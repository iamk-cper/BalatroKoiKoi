extends Label

@onready var card_slots_taken: Node = get_tree().get_root().get_node("Game/CardManager/CardSlotsTaken")
@onready var group_type: String = get_parent().get_parent().name  # Zakładamy że np. Hikari, Tane, ...

func _ready() -> void:
	_update_count()
	card_slots_taken.connect("taken_changed", _on_taken_changed)

func _on_taken_changed(group_name: String, count: int) -> void:
	_update_count()

func _update_count() -> void:
	var count := 0
	match group_type:
		"Hikari":
			count = card_slots_taken.hikari_cards.size()
			text = "Hikari: %d" % count
		"Tane":
			count = card_slots_taken.tane_cards.size()
			text = "Tane: %d" % count
		"Tanzaku":
			count = card_slots_taken.tanzaku_cards.size()
			text = "Tanzaku: %d" % count
		"Kasu":
			count = card_slots_taken.kasu_cards.size()
			text = "Kasu: %d" % count
		_:
			push_warning("UNKNOWN/: %s" % group_type)
