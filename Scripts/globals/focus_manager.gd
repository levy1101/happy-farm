extends Node

# ================================================================
# FOCUS MANAGER — Forest App style for Croptails
# 25 real minutes = 4 in-game hours
# Formula: game_speed = 240 / focus_duration_real_seconds
# ================================================================

const GAME_MINUTES_PER_SESSION: float = 4.0 * 60.0  # 240 in-game minutes = 4 hours

const FOCUS_SCREEN_SCENE = preload("res://Scenes/ui/focus_screen.tscn")

# ──── State ────────────────────────────────────────────────────
var is_focusing: bool = false
var focus_duration_seconds: float = 0.0   # total real-time seconds for session
var elapsed_seconds: float = 0.0          # real-time seconds elapsed so far
var _saved_game_speed: float = 5.0        # restored when session ends

# ──── Signals ──────────────────────────────────────────────────
signal focus_started(duration_minutes: int)
signal focus_tick(elapsed: float, total: float)
signal focus_completed
signal focus_abandoned
signal enter_focus_screen_requested

# ──── Process ──────────────────────────────────────────────────
func _process(delta: float) -> void:
	if not is_focusing:
		return
	elapsed_seconds += delta
	focus_tick.emit(elapsed_seconds, focus_duration_seconds)
	if elapsed_seconds >= focus_duration_seconds:
		_complete()

# ──── Public API ───────────────────────────────────────────────
func start_focus(duration_minutes: int) -> void:
	if is_focusing:
		return
	is_focusing = true
	elapsed_seconds = 0.0
	focus_duration_seconds = float(duration_minutes) * 60.0

	# 25 real-min → 1500 real-seconds → 240 game-minutes must advance
	# game_speed = how many game-minutes advance per real-second
	_saved_game_speed = DayAndNightCycleManager.game_speed
	DayAndNightCycleManager.game_speed = GAME_MINUTES_PER_SESSION / focus_duration_seconds

	focus_started.emit(duration_minutes)

func abandon_focus() -> void:
	if not is_focusing:
		return
	is_focusing = false
	DayAndNightCycleManager.game_speed = _saved_game_speed
	focus_abandoned.emit()

func enter_focus_screen() -> void:
	# Check if focus screen is already open
	for child in get_tree().root.get_children():
		if child.name == "FocusScreen":
			return
	var screen = FOCUS_SCREEN_SCENE.instantiate()
	screen.name = "FocusScreen"
	get_tree().root.add_child(screen)
	enter_focus_screen_requested.emit()

# ──── Private ──────────────────────────────────────────────────
func _complete() -> void:
	is_focusing = false
	DayAndNightCycleManager.game_speed = _saved_game_speed
	focus_completed.emit()
