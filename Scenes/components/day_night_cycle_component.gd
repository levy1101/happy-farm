class_name DayNightCycleComponent
extends CanvasModulate

#Export variables that sync with the time system when changed in inspector
@export var initial_day: int = 1:
	set(id): #Use setter to control other values when current value changes
		initial_day = id
		DayAndNightCycleManager.initial_day = id
		DayAndNightCycleManager.set_initial_time()

@export var initial_hour: int = 12:
	set(ih):
		initial_hour = ih
		DayAndNightCycleManager.initial_hour = ih
		DayAndNightCycleManager.set_initial_time()

@export var initial_minute: int = 30:
	set(im):
		initial_minute = im
		DayAndNightCycleManager.initial_minute = im
		DayAndNightCycleManager.set_initial_time()

@export var day_night_gradient_texture: GradientTexture1D #Custom gradient color variable to control screen tint/filter

func _ready() -> void:#Define initial values in the time system via this node's inspector
	DayAndNightCycleManager.initial_day = initial_day
	DayAndNightCycleManager.initial_hour = initial_hour
	DayAndNightCycleManager.initial_minute = initial_minute
	DayAndNightCycleManager.set_initial_time()
	DayAndNightCycleManager.game_time.connect(on_game_time)

func on_game_time(time: float) -> void:
	var sample_value = 0.5 * (sin(time - PI * 0.5) + 1.0) #Align screen tint with the current time
	color = day_night_gradient_texture.gradient.sample(sample_value) #And change the color of the bound node
