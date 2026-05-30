extends Node2D

var tomato_harvest_scene = preload("res://Scenes/objects/plants/tomato_harvest.tscn") #Mature crop scene

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var watering_particles: GPUParticles2D = $WateringParticles #Watering particles
@onready var flowering_particles: GPUParticles2D = $FloweringParticles #Flowering particles
@onready var hurt_component: HurtComponent = $HurtComponent
@onready var growth_cycle_component: GrowthCycleComponent = $GrowthCycleComponent

var growth_state : DataTypes.GrowthStates = DataTypes.GrowthStates.Seed

func _ready() -> void:
	watering_particles.emitting = false
	flowering_particles.emitting = false
	
	hurt_component.hurt.connect(on_hurt) #Detect watering
	growth_cycle_component.crop_maturity.connect(on_crop_maturity) #Convert scene when mature
	growth_cycle_component.crop_harvesting.connect(on_crop_harvesting)

func _process(delta: float) -> void:
	growth_state = growth_cycle_component.get_current_growth_state()
	sprite_2d.frame = growth_state + 6
	
	if growth_state == DataTypes.GrowthStates.Maturity:
		flowering_particles.emitting = true

func on_hurt(damage:int)->void:
	if !growth_cycle_component.is_waterd: #Trigger particle effect when watering crops
		watering_particles.emitting = true
		await get_tree().create_timer(5.0).timeout
		watering_particles.emitting = false
		growth_cycle_component.is_waterd = true
		
func on_crop_maturity() -> void:
	flowering_particles.emitting = true

func on_crop_harvesting() -> void:
	var tomato_harvest = tomato_harvest_scene.instantiate() as Node2D
	tomato_harvest.global_position = global_position
	get_parent().add_child(tomato_harvest)
	queue_free()
