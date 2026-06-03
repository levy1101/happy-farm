class_name NonPlayableCharacter extends CharacterBody2D

@export var min_walk_cycle : int = 2
@export var max_walk_cycle : int = 6
## Pen bounding box in global coordinates (set per instance in level scene)
@export var pen_bounds : Rect2 = Rect2(0, 0, 0, 0)

var walk_cycles : int
var current_walk_cycle : int # ，walk_cycles，Idle
