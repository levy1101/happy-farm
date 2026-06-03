extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var interactable_component: InteractableComponent = $InteractableComponent

@export var crop_left: float = 0.0
@export var crop_right: float = 0.0

func _ready() -> void:
	interactable_component.interactable_activated.connect(_on_interactable_activated)
	interactable_component.interactable_deactivated.connect(_on_interactable_deactivated)
	collision_layer = 1
	apply_crop()
	
func apply_crop() -> void:
	if crop_left == 0.0 and crop_right == 0.0:
		return
		
	# Duplicate sprite_frames so it is unique to this door instance
	animated_sprite_2d.sprite_frames = animated_sprite_2d.sprite_frames.duplicate()
	
	# Go through all animations and frames to crop their AtlasTextures
	for anim in animated_sprite_2d.sprite_frames.get_animation_names():
		var frame_count = animated_sprite_2d.sprite_frames.get_frame_count(anim)
		for i in range(frame_count):
			var texture = animated_sprite_2d.sprite_frames.get_frame_texture(anim, i)
			if texture is AtlasTexture:
				var new_atlas = texture.duplicate()
				var reg = new_atlas.region
				reg.position.x += crop_left
				reg.size.x -= (crop_left + crop_right)
				new_atlas.region = reg
				animated_sprite_2d.sprite_frames.set_frame(anim, i, new_atlas)
				
	# Adjust collision shape to match the new width
	if collision_shape_2d.shape is RectangleShape2D:
		var rect_shape = collision_shape_2d.shape.duplicate()
		rect_shape.size.x -= (crop_left + crop_right)
		collision_shape_2d.shape = rect_shape
		# Shift collision center to match texture crop shift
		collision_shape_2d.position.x += (crop_left - crop_right) / 2.0

func _on_interactable_activated():
	animated_sprite_2d.play("open_door")
	collision_layer = 2 # door1，player2，1，door（1），player
	
func _on_interactable_deactivated():
	animated_sprite_2d.play("close_door")
	collision_layer = 1

