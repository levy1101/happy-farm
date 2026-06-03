extends NonPlayableCharacter

func _ready() -> void:
	add_to_group("chickens")
	walk_cycles = randi_range(min_walk_cycle,max_walk_cycle)
