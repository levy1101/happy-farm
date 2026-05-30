class_name GrowthCycleComponent extends Node #Manages crop growth

@export var current_growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Germination #Crop state
@export_range(5,365) var days_util_harvest:int = 7 #Time to mature

signal crop_maturity #Signal emitted when crop is mature
signal crop_harvesting #Signal emitted when crop is harvestable

var is_waterd :bool #Whether watered
var starting_day: int
var current_day: int

func _ready() -> void:
	DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day) #Determine days by time system day signal

func on_time_tick_day(day:int) -> void:
	if is_waterd: #Only change growth state when watered
		if starting_day == 0:
			starting_day = day
		growth_states(starting_day,day) #Combine time system days and growth states
		harvest_states(starting_day,day)

func growth_states(starting_day : int, current_day : int) -> void:
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		return
	
	var num_states = 5 #Number of growth states
	
	var growth_days_passed = (current_day - starting_day) % num_states #Days passed for current growth state
	var state_index = growth_days_passed % num_states + 1 #State index

	current_growth_state = state_index #Enum types are integers, so they can be replaced by indices
	var name = DataTypes.GrowthStates.keys()[current_growth_state] #Get state by index to return integer for adjusting sprite frames
	print("Current growth state: ",name," state index: ",state_index)
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		crop_maturity.emit()


func harvest_states(starting_day : int, current_day : int) -> void:
	if current_growth_state == DataTypes.GrowthStates.Harvesting:
		return
		
	var days_passed = (current_day - starting_day ) % days_util_harvest  #Check if harvest day is reached
	
	if days_passed == days_util_harvest - 1: #days_util_harvest starts at 0, so subtract 1
		current_growth_state == DataTypes.GrowthStates.Harvesting
		crop_harvesting.emit()
		
func get_current_growth_state() -> DataTypes.GrowthStates :
	return current_growth_state
		
