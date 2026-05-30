class_name GameInputEvents

static var direction : Vector2 #Static variables share the same memory space

static func movement_input() -> Vector2:
	direction.y = Input.get_axis("walk_up","walk_down")
	direction.x = Input.get_axis("walk_left","walk_right")
	#if Input.is_action_pressed("walk_up"):
		#direction = Vector2.UP
	#elif Input.is_action_pressed("walk_down"):
		#direction = Vector2.DOWN
	#elif Input.is_action_pressed("walk_left"):
		#direction = Vector2.LEFT
	#elif Input.is_action_pressed("walk_right"):
		#direction = Vector2.RIGHT
	#else:
		#direction = Vector2.ZERO
	return direction

#Check if moving
static func is_movement_input() -> bool:
	if direction == Vector2.ZERO:
		return false
	else:
		return true

static func use_tool() -> bool:
	return Input.is_action_pressed("hit")
