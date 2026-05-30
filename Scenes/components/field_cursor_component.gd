class_name FieldCursorComponent extends Node

@export var grass: TileMapLayer
@export var tilled_soil: TileMapLayer
@export var terrain_set: int = 0 # tilemaplayer
@export var terrain:int = 3 # ，，tile

var player:Player  # @onreadynode，，

var mouse_position:Vector2 #Mouse position
var cell_position:Vector2i # tile
var cell_source_id:int # tile，-1
var local_cell_position:Vector2 #Local center cell position
var distance:float

func _ready() -> void:
	await get_tree().physics_frame #
	player = get_tree().get_first_node_in_group("player") # ，，

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_hit"): #ctrl+left
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_tilled_soil_cell()
	elif event.is_action_pressed("hit"): # left
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse() #Get clicked tile info from grass layer
			add_tilled_soil_cell() #Plant tilled_soil ground

func get_cell_under_mouse() -> void:
	# Mặc định hướng nhìn nếu chưa di chuyển là đi xuống dưới (Down)
	var facing_dir = player.player_direction
	if facing_dir == Vector2.ZERO:
		facing_dir = Vector2.DOWN
		
	# Lấy tọa độ mục tiêu cách người chơi 1 ô (16px) theo hướng nhìn
	var target_global_position = player.global_position + (facing_dir * 16)
	
	# Chuyển đổi tọa độ mục tiêu sang tọa độ map
	var local_pos = grass.to_local(target_global_position)
	cell_position = grass.local_to_map(local_pos)
	cell_source_id = grass.get_cell_source_id(cell_position)
	local_cell_position = grass.map_to_local(cell_position)
	
	# Tính khoảng cách thực tế (luôn ở cự ly gần)
	var global_cell_position = grass.to_global(local_cell_position)
	distance = player.global_position.distance_to(global_cell_position)
	
	# In debug thông tin ra console
	print("--- TILLGROUND DIRECTIONAL INTERACTION ---")
	print("Player Global Pos: ", player.global_position)
	print("Facing Direction: ", facing_dir)
	print("Tile Global Pos: ", global_cell_position)
	print("Calculated Distance: ", distance)
	print("Cell Source ID: ", cell_source_id)
	
func add_tilled_soil_cell()->void:
	if distance <= 60:
		print("SUCCESS: Tilling soil at ", cell_position)
		tilled_soil.set_cells_terrain_connect([cell_position],terrain_set,terrain,true) #Update cell position数组的tile为terrain_set集合中的terrain地形，并忽略空地形，这个方法需要设置正确的地形过度
	else:
		print("FAILED: Distance too far (", distance, " > 60)")
		
func remove_tilled_soil_cell()->void:
	if distance <= 60:
		tilled_soil.set_cells_terrain_connect([cell_position],terrain_set,0,true)  # -1，tile，grass，
