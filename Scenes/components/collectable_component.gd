class_name CollectableComponent extends Area2D

@export var collectable_name : String


func _on_body_entered(body: Node2D) -> void:
	if body is Player: #Check if it is a Player type
		InventoryManager.add_collectable(collectable_name)
		print("collectable: ",collectable_name)
		get_parent().queue_free()
