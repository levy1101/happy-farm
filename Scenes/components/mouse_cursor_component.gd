extends Node

@export var mouse: Texture2D

func _ready() -> void:
	Input.set_custom_mouse_cursor(mouse,Input.CURSOR_ARROW) # ，
