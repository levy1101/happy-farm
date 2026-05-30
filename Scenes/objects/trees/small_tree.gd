class_name SmallTree extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent #Component for detecting hurt areas
@onready var damage_component: DamageComponent = $DamageComponent #Component for taking damage

@export var log = preload("res://Scenes/objects/trees/log.tscn")

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damaged_reached)

func on_hurt(damage:int) -> void:
	damage_component.apply_damage(damage)
	material.set_shader_parameter("shake_intensity",0.8)
	await get_tree().create_timer(1.0).timeout #await pauses execution until the specified signal (timeout) triggers
	material.set_shader_parameter("shake_intensity",0.0)
	
func on_max_damaged_reached() -> void:
	call_deferred("add_log_scene")#Call deferred
	queue_free()
	
func add_log_scene() -> void:
	var log_instantiate = log.instantiate() as Node2D
	log_instantiate.global_position = global_position
	get_parent().add_child(log_instantiate)
