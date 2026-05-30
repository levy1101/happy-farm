extends Area2D

@onready var interactable_label_component: Control = $InteractableLabelComponent

var _player_in_range: bool = false

func _ready() -> void:
	add_to_group("bed_interactable")
	print("[DEBUG] BedInteractable (Direct Area2D) _ready! Global position: ", global_position)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	interactable_label_component.hide()
	
	# Set the text on the label to "K"
	var label = interactable_label_component.get_node_or_null("Label")
	if label:
		label.text = "K"

func _on_body_entered(body: Node2D) -> void:
	print("[DEBUG] Player entered BedInteractable range!")
	_player_in_range = true
	interactable_label_component.show()

func _on_body_exited(body: Node2D) -> void:
	print("[DEBUG] Player left BedInteractable range!")
	_player_in_range = false
	interactable_label_component.hide()

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and event is InputEventKey and event.pressed and not event.is_echo():
		if event.keycode == KEY_K:
			print("[DEBUG] K pressed! Entering focus screen...")
			FocusManager.enter_focus_screen()
