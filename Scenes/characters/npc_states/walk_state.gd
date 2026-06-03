extends NodeState

@export var character : NonPlayableCharacter
@export var animated_sprite_2d: AnimatedSprite2D 
@export var navigation_agent_2d : NavigationAgent2D
@export var min_speed : float = 5.0
@export var max_speed : float = 10.0

var speed: float
var last_position: Vector2
var stuck_timer: float = 0.0

func _ready() -> void:
	navigation_agent_2d.velocity_computed.connect(on_safe_velocity_computed) # 。
	call_deferred("character_setup") # 。
	navigation_agent_2d.avoidance_enabled = true
	
func character_setup() -> void:
	await get_tree().physics_frame
	set_movement_target() 

func set_movement_target() -> void:
	# If animal has a pen boundary set, stay within it
	if character.pen_bounds.size != Vector2.ZERO:
		var bounds = character.pen_bounds
		var random_point = Vector2(
			randf_range(bounds.position.x, bounds.position.x + bounds.size.x),
			randf_range(bounds.position.y, bounds.position.y + bounds.size.y)
		)
		navigation_agent_2d.target_position = random_point
		speed = randf_range(min_speed, max_speed)
		return

	# Fallback: random point anywhere on the navigation map
	var target_position : Vector2 = NavigationServer2D.map_get_random_point(navigation_agent_2d.get_navigation_map(),navigation_agent_2d.navigation_layers,false)
	navigation_agent_2d.target_position = target_position
	speed = randf_range(min_speed,max_speed)

	

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(delta : float) -> void:
	if navigation_agent_2d.is_navigation_finished(): # ，+1
		character.current_walk_cycle += 1
		set_movement_target()
		last_position = character.global_position
		stuck_timer = 0.0
		return
			
	var target_position = navigation_agent_2d.get_next_path_position()
	var target_direction = character.global_position.direction_to(target_position)
	var velocity : Vector2 = target_direction * speed
	if navigation_agent_2d.avoidance_enabled:
		animated_sprite_2d.flip_h = velocity.x < 0
		navigation_agent_2d.velocity = velocity  # NavigationAgent2D  velocity ，，。
	else:
		character.velocity = velocity
		character.move_and_slide() 

	# Stuck detection
	stuck_timer += delta
	if stuck_timer >= 1.0:
		var distance_moved = character.global_position.distance_to(last_position)
		if distance_moved < 2.0:
			set_movement_target()
		last_position = character.global_position
		stuck_timer = 0.0

func on_safe_velocity_computed(safe_velocity : Vector2)->void: # ，精度，velocity_computed
	animated_sprite_2d.flip_h = safe_velocity.x < 0
	character.velocity = safe_velocity 
	character.move_and_slide() 

func _on_next_transitions() -> void:
	if character.current_walk_cycle == character.walk_cycles:
		character.velocity = Vector2.ZERO
		transition.emit("Idle")


func _on_enter() -> void:
	animated_sprite_2d.play("walk")
	character.current_walk_cycle = 0
	last_position = character.global_position
	stuck_timer = 0.0

func _on_exit() -> void:
	animated_sprite_2d.stop()

