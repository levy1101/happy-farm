extends CanvasLayer

# ================================================================
# FOCUS SCREEN — Premium Forest App full-screen experience
# All UI built programmatically for gorgeous responsive scaling.
# ================================================================

const DURATIONS: Array = [25, 45, 60]

var _selected_duration: int = 25
var _is_active: bool = false
var _has_completed: bool = false

# ──── UI References ────────────────────────────────────────────
var _bg: ColorRect
var _clone_avatar: AnimatedSprite2D
var _content_root: Control

var _avatar_panel: PanelContainer
var _title_label: Label
var _dur_hint: Label
var _duration_row: HBoxContainer
var _duration_buttons: Array = []
var _progress_ring: FocusProgressRing
var _tree_sprite: Sprite2D
var _countdown_label: Label
var _status_label: Label
var _action_btn: Button
var _close_btn: Button

# ──── Custom Draw Progress Ring ─────────────────────────────────
class FocusProgressRing extends Control:
	var progress: float = 0.0 : set = _set_progress

	func _set_progress(val: float) -> void:
		progress = val
		queue_redraw()

	func _draw() -> void:
		var center = size / 2.0
		var radius = min(size.x, size.y) / 2.0 - 4.0
		# Draw elegant dark forest green background ring
		draw_arc(center, radius, 0.0, TAU, 128, Color(0.06, 0.16, 0.08), 5.0, true)
		# Draw glowing vibrant progress arc starting from top (-90 degrees)
		if progress > 0.0:
			var start_angle = -PI / 2.0
			var end_angle = start_angle + progress * TAU
			# Draw arc shadow
			draw_arc(center, radius, start_angle, end_angle, 128, Color(0.1, 0.4, 0.2), 7.0, true)
			# Draw actual progress arc
			draw_arc(center, radius, start_angle, end_angle, 128, Color(0.3, 0.95, 0.4), 4.0, true)

# ──── Lifecycle ────────────────────────────────────────────────
func _ready() -> void:
	# Keep layer high to cover normal game HUD
	layer = 100
	_build_ui()
	_connect_signals()
	_set_idle_mode()
	_run_entrance_transition()

func _connect_signals() -> void:
	FocusManager.focus_started.connect(_on_focus_started)
	FocusManager.focus_tick.connect(_on_focus_tick)
	FocusManager.focus_completed.connect(_on_focus_completed)
	FocusManager.focus_abandoned.connect(_on_focus_abandoned)

func _build_ui() -> void:
	# 1. Dark background
	_bg = ColorRect.new()
	_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	# Start transparent for transition
	_bg.color = Color(0.03, 0.09, 0.04, 0.0)
	add_child(_bg)

	# 2. Content container (hidden during transition)
	_content_root = Control.new()
	_content_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_content_root.modulate.a = 0.0
	add_child(_content_root)

	# Center vertical layout
	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 8)
	_content_root.add_child(vbox)

	# ── Top Section (Avatar & Title) ──
	var top_vbox = VBoxContainer.new()
	top_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	top_vbox.add_theme_constant_override("separation", 4)
	vbox.add_child(top_vbox)

	# Circular Avatar Frame
	_avatar_panel = PanelContainer.new()
	_avatar_panel.custom_minimum_size = Vector2(40, 40)
	_avatar_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	var style_circle = StyleBoxFlat.new()
	style_circle.bg_color = Color(0.08, 0.22, 0.11)
	style_circle.corner_radius_top_left = 20
	style_circle.corner_radius_top_right = 20
	style_circle.corner_radius_bottom_left = 20
	style_circle.corner_radius_bottom_right = 20
	style_circle.border_width_left = 2
	style_circle.border_width_top = 2
	style_circle.border_width_right = 2
	style_circle.border_width_bottom = 2
	style_circle.border_color = Color(1, 1, 1, 0.9)
	_avatar_panel.add_theme_stylebox_override("panel", style_circle)
	top_vbox.add_child(_avatar_panel)

	# Title
	_title_label = Label.new()
	_title_label.text = "FOCUS MODE"
	_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var font_settings = LabelSettings.new()
	font_settings.font_size = 14
	font_settings.font_color = Color(1.0, 1.0, 1.0)
	font_settings.shadow_color = Color(0, 0, 0, 0.5)
	font_settings.shadow_offset = Vector2(1, 1)
	_title_label.label_settings = font_settings
	top_vbox.add_child(_title_label)

	# ── Ring Progress Section ──
	var center_control = Control.new()
	center_control.custom_minimum_size = Vector2(140, 140)
	center_control.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.add_child(center_control)

	_progress_ring = FocusProgressRing.new()
	_progress_ring.set_anchors_preset(Control.PRESET_FULL_RECT)
	center_control.add_child(_progress_ring)

	# Growing Tree Sprite (inside the ring)
	_tree_sprite = Sprite2D.new()
	_tree_sprite.texture = preload("res://Assets/game/Objects/Basic_Plants.png")
	_tree_sprite.hframes = 6
	_tree_sprite.vframes = 2
	_tree_sprite.frame = 0
	_tree_sprite.position = Vector2(70, 52)
	_tree_sprite.scale = Vector2(2.5, 2.5) # nice and visible
	center_control.add_child(_tree_sprite)

	# Big countdown label
	_countdown_label = Label.new()
	_countdown_label.text = "25:00"
	_countdown_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_countdown_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	var cd_settings = LabelSettings.new()
	cd_settings.font_size = 20
	cd_settings.font_color = Color(1, 1, 1)
	_countdown_label.label_settings = cd_settings
	_countdown_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	# position label in bottom third of the ring
	_countdown_label.offset_top = 80
	center_control.add_child(_countdown_label)

	# ── Duration and Status Hint ──
	_dur_hint = Label.new()
	_dur_hint.text = "25 min real = 4 hrs in-game ⏰"
	_dur_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var hint_settings = LabelSettings.new()
	hint_settings.font_size = 8
	hint_settings.font_color = Color(0.7, 1.0, 0.7, 0.8)
	_dur_hint.label_settings = hint_settings
	vbox.add_child(_dur_hint)

	# ── Duration pills ──
	_duration_row = HBoxContainer.new()
	_duration_row.alignment = BoxContainer.ALIGNMENT_CENTER
	_duration_row.add_theme_constant_override("separation", 10)
	vbox.add_child(_duration_row)

	var style_normal = StyleBoxFlat.new()
	style_normal.bg_color = Color(0.08, 0.22, 0.11)
	style_normal.corner_radius_top_left = 12
	style_normal.corner_radius_top_right = 12
	style_normal.corner_radius_bottom_left = 12
	style_normal.corner_radius_bottom_right = 12
	style_normal.border_width_left = 1
	style_normal.border_width_top = 1
	style_normal.border_width_right = 1
	style_normal.border_width_bottom = 1
	style_normal.border_color = Color(0.2, 0.5, 0.3)

	for mins in DURATIONS:
		var btn = Button.new()
		btn.text = "%d min" % mins
		btn.custom_minimum_size = Vector2(65, 26)
		btn.add_theme_stylebox_override("normal", style_normal)
		btn.add_theme_stylebox_override("hover", style_normal)
		btn.add_theme_stylebox_override("pressed", style_normal)
		btn.add_theme_font_size_override("font_size", 9)
		btn.pressed.connect(_on_duration_selected.bind(mins))
		_duration_row.add_child(btn)
		_duration_buttons.append(btn)

	# ── Status text ──
	_status_label = Label.new()
	_status_label.text = "Plant a tree and stay focused!\nAbandon = tree dies 🥀"
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var status_settings = LabelSettings.new()
	status_settings.font_size = 9
	status_settings.font_color = Color(0.8, 0.9, 0.8)
	_status_label.label_settings = status_settings
	vbox.add_child(_status_label)

	# ── Buttons row ──
	var btn_row = HBoxContainer.new()
	btn_row.alignment = BoxContainer.ALIGNMENT_CENTER
	btn_row.add_theme_constant_override("separation", 12)
	vbox.add_child(btn_row)

	var style_action = StyleBoxFlat.new()
	style_action.bg_color = Color(0.12, 0.45, 0.22)
	style_action.corner_radius_top_left = 14
	style_action.corner_radius_top_right = 14
	style_action.corner_radius_bottom_left = 14
	style_action.corner_radius_bottom_right = 14

	_action_btn = Button.new()
	_action_btn.text = "🌱 Start Growing"
	_action_btn.custom_minimum_size = Vector2(130, 30)
	_action_btn.add_theme_stylebox_override("normal", style_action)
	_action_btn.add_theme_font_size_override("font_size", 10)
	_action_btn.pressed.connect(_on_action_pressed)
	btn_row.add_child(_action_btn)

	var style_close = StyleBoxFlat.new()
	style_close.bg_color = Color(0.35, 0.15, 0.15)
	style_close.corner_radius_top_left = 14
	style_close.corner_radius_top_right = 14
	style_close.corner_radius_bottom_left = 14
	style_close.corner_radius_bottom_right = 14

	_close_btn = Button.new()
	_close_btn.text = "✕ Close"
	_close_btn.custom_minimum_size = Vector2(75, 30)
	_close_btn.add_theme_stylebox_override("normal", style_close)
	_close_btn.add_theme_font_size_override("font_size", 10)
	_close_btn.pressed.connect(_on_close_pressed)
	btn_row.add_child(_close_btn)

# ──── Transition Logic ──────────────────────────────────────────
func _run_entrance_transition() -> void:
	# Find EmotesPanel in the tree
	var emotes_panel = _find_emotes_panel(get_tree().root)
	if not emotes_panel:
		# Fallback: instantly fade in
		var t = create_tween()
		t.tween_property(_bg, "color:a", 0.95, 0.3)
		t.tween_property(_content_root, "modulate:a", 1.0, 0.3)
		return

	# Hide original emotes panel during transition
	emotes_panel.visible = false

	# Create transition avatar clone
	var original_sprite = emotes_panel.get_node_or_null("Emote/AnimatedSprite2D")
	if original_sprite:
		_clone_avatar = AnimatedSprite2D.new()
		_clone_avatar.sprite_frames = original_sprite.sprite_frames
		_clone_avatar.animation = original_sprite.animation
		_clone_avatar.frame = original_sprite.frame
		_clone_avatar.play(original_sprite.animation)
		
		# Position clone exactly at emotes_panel center
		var g_rect = emotes_panel.get_global_rect()
		_clone_avatar.global_position = g_rect.position + g_rect.size / 2.0
		_clone_avatar.scale = Vector2(1.0, 1.0)
		add_child(_clone_avatar)

	# Run parallax expansion tween
	var tween = create_tween().set_parallel(true)
	tween.tween_property(_bg, "color:a", 0.96, 0.6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	if _clone_avatar:
		# Zoom out from top-left, expanding to center of the viewport (internal size 640x360)
		tween.tween_property(_clone_avatar, "global_position", Vector2(320, 180), 0.6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(_clone_avatar, "scale", Vector2(12.0, 12.0), 0.6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	# When expansion ends, fade clone out and fade UI in
	await tween.finished
	
	var tween_reveal = create_tween().set_parallel(true)
	if _clone_avatar:
		tween_reveal.tween_property(_clone_avatar, "modulate:a", 0.0, 0.25)
	tween_reveal.tween_property(_content_root, "modulate:a", 1.0, 0.35)
	
	# Instantiate actual Teemo sprite inside the White Glow Circle Avatar frame
	if original_sprite:
		var inner_avatar = AnimatedSprite2D.new()
		inner_avatar.sprite_frames = original_sprite.sprite_frames
		inner_avatar.animation = "emote_1_idle"
		inner_avatar.play("emote_1_idle")
		inner_avatar.position = Vector2(20, 20) # center of 40x40 panel
		inner_avatar.scale = Vector2(0.9, 0.9)
		_avatar_panel.add_child(inner_avatar)

	await tween_reveal.finished
	if _clone_avatar:
		_clone_avatar.queue_free()
		_clone_avatar = null

func _find_emotes_panel(node: Node) -> Node:
	if node.name == "EmotesPanel":
		return node
	for child in node.get_children():
		var found = _find_emotes_panel(child)
		if found:
			return found
	return null

# ──── Interactions ──────────────────────────────────────────────
func _on_duration_selected(mins: int) -> void:
	if _is_active:
		return
	_selected_duration = mins
	_refresh_duration_buttons()
	_update_countdown_display(0.0, float(mins) * 60.0)

func _refresh_duration_buttons() -> void:
	for i in _duration_buttons.size():
		var btn: Button = _duration_buttons[i]
		btn.disabled = _is_active
		if DURATIONS[i] == _selected_duration:
			btn.modulate = Color(0.4, 1.0, 0.5)
		else:
			btn.modulate = Color.WHITE

func _on_action_pressed() -> void:
	if _is_active:
		FocusManager.abandon_focus()
	else:
		FocusManager.start_focus(_selected_duration)

func _on_close_pressed() -> void:
	if not _is_active:
		# Unhide original emotes panel
		var emotes_panel = _find_emotes_panel(get_tree().root)
		if emotes_panel:
			emotes_panel.visible = true
		
		# Slide/Fade out transition
		var tween = create_tween().set_parallel(true)
		tween.tween_property(_content_root, "modulate:a", 0.0, 0.25)
		tween.tween_property(_bg, "color:a", 0.0, 0.3)
		await tween.finished
		queue_free()

# ──── FocusManager Signal Handlers ─────────────────────────────
func _on_focus_started(_duration_minutes: int) -> void:
	_is_active = true
	_set_active_mode()

func _on_focus_tick(elapsed: float, total: float) -> void:
	_update_countdown_display(elapsed, total)
	_progress_ring.progress = elapsed / total
	
	# Crop sprite stages: Tomato growth cycles (frame 0 to 5 of Basic_Plants.png)
	var progress: float = elapsed / total
	if progress < 0.2:
		_tree_sprite.frame = 0 # small sprout
	elif progress < 0.4:
		_tree_sprite.frame = 1 # sprout leaves
	elif progress < 0.6:
		_tree_sprite.frame = 2 # growing plant
	elif progress < 0.8:
		_tree_sprite.frame = 3 # taller crop
	elif progress < 0.95:
		_tree_sprite.frame = 4 # flowering
	else:
		_tree_sprite.frame = 5 # full fruit!

func _on_focus_completed() -> void:
	_is_active = false
	_has_completed = true
	_tree_sprite.frame = 5
	_countdown_label.text = "00:00"
	_progress_ring.progress = 1.0
	_status_label.text = "🎉 Your tree has bloomed! Outstanding focus!"
	_action_btn.text = "🌸 Success!"
	_action_btn.disabled = true
	_close_btn.visible = true
	_duration_row.visible = true
	_refresh_duration_buttons()

func _on_focus_abandoned() -> void:
	_is_active = false
	_tree_sprite.frame = 0
	_countdown_label.text = "--:--"
	_status_label.text = "🥀 The tree has wilted..."
	_action_btn.text = "Try Again"
	_action_btn.disabled = false
	_duration_row.visible = true
	_close_btn.visible = true
	_refresh_duration_buttons()
	
	# Auto-reset status after 3 seconds
	await get_tree().create_timer(3.0).timeout
	if is_instance_valid(self) and not _is_active:
		_set_idle_mode()

# ──── Mode Helpers ─────────────────────────────────────────────
func _set_idle_mode() -> void:
	_is_active = false
	_has_completed = false
	_tree_sprite.frame = 0
	_status_label.text = "Plant a tree and stay focused!\nAbandon = tree dies 🥀"
	_action_btn.text = "🌱 Start Growing"
	_action_btn.disabled = false
	_close_btn.visible = true
	_duration_row.visible = true
	_progress_ring.progress = 0.0
	_refresh_duration_buttons()
	_update_countdown_display(0.0, float(_selected_duration) * 60.0)

func _set_active_mode() -> void:
	_tree_sprite.frame = 0
	_status_label.text = "Stay focused! Your tree is growing..."
	_action_btn.text = "🗑️ Abandon (kills tree)"
	_action_btn.disabled = false
	_close_btn.visible = false  # Can't close while focusing!
	_duration_row.visible = false

# ──── Display Helpers ──────────────────────────────────────────
func _update_countdown_display(elapsed: float, total: float) -> void:
	var remaining: float = max(0.0, total - elapsed)
	var mins: int = int(remaining) / 60
	var secs: int = int(remaining) % 60
	_countdown_label.text = "%02d:%02d" % [mins, secs]
