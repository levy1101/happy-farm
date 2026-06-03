extends Node2D

## Chicken pen bounding box in global coordinates
const CHICKEN_PEN := Rect2(210, 50, 275, 265)
## Cow pen bounding box in global coordinates
const COW_PEN := Rect2(720, 384, 288, 224)

const DOOR_SCENE = preload("res://Scenes/houses/door.tscn")

@onready var game_tile_map: Node2D = $GameTileMap
@onready var fencens: TileMapLayer = $GameTileMap/Fencens

func _ready() -> void:
	# Wait a frame so all child nodes are fully ready
	await get_tree().process_frame

	# Set pen boundary for every chicken - they will only walk inside this box
	for chicken in get_tree().get_nodes_in_group("chickens"):
		chicken.pen_bounds = CHICKEN_PEN
		if not CHICKEN_PEN.has_point(chicken.global_position):
			chicken.global_position = Vector2(340, 160)

	# Set pen boundary for every cow - they will only walk inside this box
	for cow in get_tree().get_nodes_in_group("cows"):
		cow.pen_bounds = COW_PEN
		if not COW_PEN.has_point(cow.global_position):
			cow.global_position = Vector2(860, 500)

	# Modify chicken pen fences to close gaps around the door:
	fencens.set_cell(Vector2i(15, 18), 5, Vector2i(2, 3))
	fencens.set_cell(Vector2i(16, 18), 5, Vector2i(2, 3))
	fencens.set_cell(Vector2i(18, 18), 5, Vector2i(2, 3))
	fencens.set_cell(Vector2i(19, 18), 5, Vector2i(2, 3))
	fencens.set_cell(Vector2i(20, 18), 5, Vector2i(2, 3))
	spawn_door(Vector2i(17, 18))

	# Modify cow pen fences to close gaps:
	# Close left wall gap completely:
	fencens.set_cell(Vector2i(45, 24), 5, Vector2i(0, 1))
	fencens.set_cell(Vector2i(45, 25), 5, Vector2i(0, 1))
	fencens.set_cell(Vector2i(45, 26), 5, Vector2i(0, 1))
	fencens.set_cell(Vector2i(45, 27), 5, Vector2i(0, 1))

	# Bottom wall: Place door at (47, 38) and fill surrounding gaps:
	fencens.set_cell(Vector2i(46, 38), 5, Vector2i(2, 3))
	fencens.set_cell(Vector2i(48, 38), 5, Vector2i(2, 3))
	fencens.set_cell(Vector2i(49, 38), 5, Vector2i(2, 3))
	spawn_door(Vector2i(47, 38))

	# Bottom-right corner alignment:
	fencens.set_cell(Vector2i(60, 38), 5, Vector2i(2, 3))
	fencens.set_cell(Vector2i(61, 38), 5, Vector2i(2, 3))
	fencens.set_cell(Vector2i(62, 38), 5, Vector2i(2, 3))
	fencens.set_cell(Vector2i(63, 38), 5, Vector2i(3, 2))
	fencens.set_cell(Vector2i(63, 37), 5, Vector2i(0, 1))

func spawn_door(tile_pos: Vector2i) -> void:
	var door = DOOR_SCENE.instantiate()
	door.crop_left = 12.0   
	door.crop_right = 12.0  
	door.global_position = fencens.to_global(fencens.map_to_local(tile_pos))
	door.scale = game_tile_map.scale
	add_child(door)

