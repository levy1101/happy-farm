class_name CropsCursorComponent extends Node

@export var tilled_soil: TileMapLayer
@export var terrain_set: int = 0 # tilemaplayer
@export var terrain:int = 3 

var player:Player
@onready var corn = preload("res://Scenes/objects/plants/corn.tscn")
@onready var tomato = preload("res://Scenes/objects/plants/tomato.tscn")

var mouse_position:Vector2 #Mouse position
var cell_position:Vector2i # tile
var cell_source_id:int
var local_cell_position:Vector2 #Local center cell position
var distance:float

func _ready() -> void:
	await get_tree().physics_frame #
	player = get_tree().get_first_node_in_group("player")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_hit"): #ctrl+left
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_crop()
	elif event.is_action_pressed("hit"): # left
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn or ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			get_cell_under_mouse() # tilled_soiltile
			add_crop() #Plant tilled_soil ground
			
func get_cell_under_mouse() -> void:
	# Mặc định hướng nhìn nếu chưa di chuyển là đi xuống dưới (Down)
	var facing_dir = player.player_direction
	if facing_dir == Vector2.ZERO:
		facing_dir = Vector2.DOWN
		
	# Lấy tọa độ mục tiêu cách người chơi 1 ô (16px) theo hướng nhìn
	var target_global_position = player.global_position + (facing_dir * 16)
	
	# Chuyển đổi tọa độ mục tiêu sang tọa độ map
	var local_pos = tilled_soil.to_local(target_global_position)
	cell_position = tilled_soil.local_to_map(local_pos)
	cell_source_id = tilled_soil.get_cell_source_id(cell_position)
	local_cell_position = tilled_soil.map_to_local(cell_position)
	
	# Tính khoảng cách thực tế (luôn ở cự ly gần)
	var global_cell_position = tilled_soil.to_global(local_cell_position)
	distance = player.global_position.distance_to(global_cell_position)
	
	# In debug thông tin ra console
	print("--- PLANT CROP DIRECTIONAL INTERACTION ---")
	print("Player Global Pos: ", player.global_position)
	print("Facing Direction: ", facing_dir)
	print("Tile Global Pos: ", global_cell_position)
	print("Calculated Distance: ", distance)
	print("Cell Source ID (TilledSoil): ", cell_source_id)
	
func add_crop() -> void:
	if distance < 60:
		if cell_source_id == -1:
			print("FAILED: Cannot plant here, soil is not tilled.")
			return
			
		var global_cell_position = tilled_soil.to_global(local_cell_position)
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn:
			print("SUCCESS: Planting Corn at ", cell_position)
			var corn_instance = corn.instantiate() as Node2D
			corn_instance.global_position = global_cell_position
			get_parent().find_child("CropsField").add_child(corn_instance)
		if ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			print("SUCCESS: Planting Tomato at ", cell_position)
			var tomato_instance = tomato.instantiate() as Node2D
			tomato_instance.global_position = global_cell_position
			get_parent().find_child("CropsField").add_child(tomato_instance)
	else:
		print("FAILED: Distance too far (", distance, " > 60)")
				
	
func remove_crop() -> void:
	if distance < 60:
		var crop_nodes = get_parent().find_child("CropsField").get_children()
		var global_cell_position = tilled_soil.to_global(local_cell_position)
		
		for i:Node2D in crop_nodes:
			if i.global_position == global_cell_position:
				i.queue_free()
