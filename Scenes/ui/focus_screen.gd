extends CanvasLayer

# ================================================================
# FOCUS SCREEN — Clean premium design matching the mockup exactly
# ================================================================

const DURATIONS: Array = [25, 45, 60]

var _selected_duration: int = 25
var _is_active: bool = false
var _plant_row_offset: int = 0
var _is_completed: bool = false

# ──── UI References ─────────────────────────────────────────────
var _bg: ColorRect
var _clone_avatar: AnimatedSprite2D
var _content_root: Control
var _avatar_panel: Control
var _progress_ring: FocusProgressRing
var _tree_sprite: Sprite2D
var _countdown_label: Label
var _status_label: Label
var _duration_row: HBoxContainer
var _duration_buttons: Array = []
var _action_btn: Button
var _close_btn: Button

# Load Kenney Mini Square font for full styling consistency
var custom_font: Font = preload("res://Assets/font/Kenney Mini Square.ttf")


# ──── Progress Ring (neon glow, 3 layer arc) ────────────────────
class FocusProgressRing extends Control:
	var progress: float = 0.0 : set = _set_progress

	func _set_progress(v: float) -> void:
		progress = v
		queue_redraw()

	func _draw() -> void:
		var c = size / 2.0
		var r = min(size.x, size.y) / 2.0 - 4.0

		# Background ring - dark muted green
		draw_arc(c, r, 0.0, TAU, 128, Color(0.06, 0.15, 0.08), 5.0, true)

		if progress > 0.0:
			var a0 = -PI / 2.0
			var a1 = a0 + progress * TAU
			# 3-layer neon glow
			draw_arc(c, r, a0, a1, 128, Color(0.3, 0.9, 0.4, 0.18), 13.0, true)
			draw_arc(c, r, a0, a1, 128, Color(0.3, 0.9, 0.4, 0.50), 7.0, true)
			draw_arc(c, r, a0, a1, 128, Color(0.85, 1.0, 0.88, 0.95), 3.0, true)

# ──── Lifecycle ─────────────────────────────────────────────────
func _ready() -> void:
	layer = 100
	_plant_row_offset = (randi() % 2) * 6
	_build_ui()
	_connect_signals()
	_set_idle_mode()
	_run_entrance_transition()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		# Check for Backslash key (which is Key.KEY_BACKSLASH or KEY_BACKSLASH)
		if event.keycode == KEY_BACKSLASH:
			if _is_active and FocusManager.is_focusing:
				# Advance 60 seconds (1 minute) per press
				FocusManager.elapsed_seconds = min(FocusManager.focus_duration_seconds, FocusManager.elapsed_seconds + 60.0)
				# Trigger an immediate tick update
				FocusManager.focus_tick.emit(FocusManager.elapsed_seconds, FocusManager.focus_duration_seconds)

func _connect_signals() -> void:
	FocusManager.focus_started.connect(_on_focus_started)
	FocusManager.focus_tick.connect(_on_focus_tick)
	FocusManager.focus_completed.connect(_on_focus_completed)
	FocusManager.focus_abandoned.connect(_on_focus_abandoned)

func _build_ui() -> void:
	# === BACKGROUND ===
	_bg = ColorRect.new()
	_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_bg.color = Color(0.03, 0.08, 0.04, 0.0)
	add_child(_bg)


	# === CONTENT ROOT (faded in during transition) ===
	_content_root = Control.new()
	_content_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_content_root.modulate.a = 0.0
	add_child(_content_root)

	# CenterContainer to keep everything vertically centered
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	_content_root.add_child(center)

	# Glass card - made more compact
	var card = PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	card.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var card_s = StyleBoxFlat.new()
	card_s.bg_color = Color(0.05, 0.17, 0.08, 0.92)
	card_s.corner_radius_top_left    = 16
	card_s.corner_radius_top_right   = 16
	card_s.corner_radius_bottom_left = 16
	card_s.corner_radius_bottom_right = 16
	card_s.border_width_left  = 1; card_s.border_width_right  = 1
	card_s.border_width_top   = 1; card_s.border_width_bottom = 1
	card_s.border_color = Color(0.25, 0.65, 0.32, 0.45)
	card_s.shadow_color = Color(0, 0.2, 0.04, 0.4)
	card_s.shadow_size = 8
	card_s.content_margin_left  = 18; card_s.content_margin_right  = 18
	card_s.content_margin_top   = 12; card_s.content_margin_bottom = 12
	card.add_theme_stylebox_override("panel", card_s)
	center.add_child(card)

	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 6)
	card.add_child(vbox)

	# === AVATAR CIRCLE ===
	# Outer wrapper for layout; holds glow ring + viewport (reduced to 44x44)
	var avatar_wrapper = Control.new()
	avatar_wrapper.custom_minimum_size = Vector2(44, 44)
	avatar_wrapper.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.add_child(avatar_wrapper)

	# Glow ring panel
	var ring_panel = Panel.new()
	ring_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	var ring_s = StyleBoxFlat.new()
	ring_s.bg_color = Color(0.04, 0.14, 0.07)
	ring_s.corner_radius_top_left    = 22
	ring_s.corner_radius_top_right   = 22
	ring_s.corner_radius_bottom_left = 22
	ring_s.corner_radius_bottom_right = 22
	ring_s.border_width_left  = 2; ring_s.border_width_right  = 2
	ring_s.border_width_top   = 2; ring_s.border_width_bottom = 2
	ring_s.border_color = Color(0.35, 1.0, 0.45)
	ring_s.shadow_color = Color(0.35, 1.0, 0.45, 0.55)
	ring_s.shadow_size = 5
	ring_panel.add_theme_stylebox_override("panel", ring_s)
	avatar_wrapper.add_child(ring_panel)

	# SubViewportContainer for the AnimatedSprite2D avatar
	var svc = SubViewportContainer.new()
	svc.stretch = true
	svc.set_anchors_preset(Control.PRESET_FULL_RECT)
	avatar_wrapper.add_child(svc)

	_avatar_panel = avatar_wrapper  # used later to get global_rect for transition

	var svp = SubViewport.new()
	svp.size = Vector2i(44, 44)
	svp.transparent_bg = true
	svp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	svc.add_child(svp)

	# === TITLE ===
	var title = Label.new()
	title.text = "FOCUS MODE"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var ts = LabelSettings.new()
	ts.font = custom_font
	ts.font_size = 14
	ts.font_color = Color(0.92, 1.0, 0.92)
	ts.shadow_color = Color(0, 0.2, 0.05, 0.6)
	ts.shadow_offset = Vector2(1, 1)
	title.label_settings = ts
	vbox.add_child(title)

	# === RING + TREE ===
	var ring_wrapper = Control.new()
	ring_wrapper.custom_minimum_size = Vector2(116, 116)
	ring_wrapper.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.add_child(ring_wrapper)

	_progress_ring = FocusProgressRing.new()
	_progress_ring.set_anchors_preset(Control.PRESET_FULL_RECT)
	ring_wrapper.add_child(_progress_ring)

	_tree_sprite = Sprite2D.new()
	_tree_sprite.texture = preload("res://Assets/game/Objects/Basic_Plants.png")
	_tree_sprite.hframes = 6
	_tree_sprite.vframes = 2
	_tree_sprite.frame = _plant_row_offset
	_tree_sprite.position = Vector2(58, 42) # Horizontally centered (116/2) and vertically placed above timer
	_tree_sprite.scale = Vector2(1.8, 1.8)
	ring_wrapper.add_child(_tree_sprite)

	_countdown_label = Label.new()
	_countdown_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_countdown_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	var cs = LabelSettings.new()
	cs.font = custom_font
	cs.font_size = 18
	cs.font_color = Color(1, 1, 1)
	cs.shadow_color = Color(0, 0.1, 0, 0.6)
	cs.shadow_offset = Vector2(0, 1)
	_countdown_label.label_settings = cs
	_countdown_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	# Center it vertically in the lower half of the 116x116 ring, aligned exactly to the center line of the circle
	_countdown_label.offset_top = 66
	_countdown_label.offset_bottom = -14
	ring_wrapper.add_child(_countdown_label)

	# === HINT ===
	var hint = Label.new()
	hint.text = "25 min real = 4 hrs in-game ⏰"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var hs = LabelSettings.new()
	hs.font = custom_font
	hs.font_size = 8
	hs.font_color = Color(0.7, 0.95, 0.7, 0.85)
	hint.label_settings = hs
	vbox.add_child(hint)

	# === DURATION PILLS ===
	_duration_row = HBoxContainer.new()
	_duration_row.alignment = BoxContainer.ALIGNMENT_CENTER
	_duration_row.add_theme_constant_override("separation", 6)
	vbox.add_child(_duration_row)

	var pill_style = StyleBoxFlat.new()
	pill_style.bg_color = Color(0.05, 0.16, 0.08)
	pill_style.corner_radius_top_left    = 10
	pill_style.corner_radius_top_right   = 10
	pill_style.corner_radius_bottom_left = 10
	pill_style.corner_radius_bottom_right = 10
	pill_style.border_width_left  = 1; pill_style.border_width_right  = 1
	pill_style.border_width_top   = 1; pill_style.border_width_bottom = 1
	pill_style.border_color = Color(0.22, 0.52, 0.28)

	for mins in DURATIONS:
		var btn = Button.new()
		btn.text = "%d min" % mins
		btn.custom_minimum_size = Vector2(56, 22)
		btn.add_theme_stylebox_override("normal", pill_style)
		btn.add_theme_stylebox_override("hover", pill_style)
		btn.add_theme_stylebox_override("pressed", pill_style)
		btn.add_theme_font_override("font", custom_font)
		btn.add_theme_font_size_override("font_size", 8)
		btn.pressed.connect(_on_duration_selected.bind(mins))
		_duration_row.add_child(btn)
		_duration_buttons.append(btn)

	# === STATUS TEXT ===
	_status_label = Label.new()
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var ss = LabelSettings.new()
	ss.font = custom_font
	ss.font_size = 8
	ss.font_color = Color(0.85, 0.95, 0.85)
	_status_label.label_settings = ss
	vbox.add_child(_status_label)

	# === ACTION BUTTONS ===
	var btn_row = HBoxContainer.new()
	btn_row.alignment = BoxContainer.ALIGNMENT_CENTER
	btn_row.add_theme_constant_override("separation", 8)
	vbox.add_child(btn_row)

	var go_style = StyleBoxFlat.new()
	go_style.bg_color = Color(0.13, 0.50, 0.22)
	go_style.corner_radius_top_left    = 12
	go_style.corner_radius_top_right   = 12
	go_style.corner_radius_bottom_left = 12
	go_style.corner_radius_bottom_right = 12
	go_style.shadow_color = Color(0.12, 0.55, 0.22, 0.3)
	go_style.shadow_size = 4

	_action_btn = Button.new()
	_action_btn.text = "🌱 Start Growing"
	_action_btn.custom_minimum_size = Vector2(100, 26)
	_action_btn.add_theme_stylebox_override("normal", go_style)
	_action_btn.add_theme_stylebox_override("hover", go_style)
	_action_btn.add_theme_stylebox_override("pressed", go_style)
	_action_btn.add_theme_font_override("font", custom_font)
	_action_btn.add_theme_font_size_override("font_size", 8)
	_action_btn.pressed.connect(_on_action_pressed)
	btn_row.add_child(_action_btn)

	var cl_style = StyleBoxFlat.new()
	cl_style.bg_color = Color(0.17, 0.17, 0.17, 0.92)
	cl_style.corner_radius_top_left    = 12
	cl_style.corner_radius_top_right   = 12
	cl_style.corner_radius_bottom_left = 12
	cl_style.corner_radius_bottom_right = 12
	cl_style.border_width_left  = 1; cl_style.border_width_right  = 1
	cl_style.border_width_top   = 1; cl_style.border_width_bottom = 1
	cl_style.border_color = Color(0.4, 0.4, 0.4, 0.35)

	_close_btn = Button.new()
	_close_btn.text = "✕ Close"
	_close_btn.custom_minimum_size = Vector2(64, 26)
	_close_btn.add_theme_stylebox_override("normal", cl_style)
	_close_btn.add_theme_stylebox_override("hover", cl_style)
	_close_btn.add_theme_stylebox_override("pressed", cl_style)
	_close_btn.add_theme_font_override("font", custom_font)
	_close_btn.add_theme_font_size_override("font_size", 8)
	_close_btn.pressed.connect(_on_close_pressed)
	btn_row.add_child(_close_btn)

# ──── Entrance Transition ───────────────────────────────────────
func _run_entrance_transition() -> void:
	var emotes_panel = _find_node("EmotesPanel", get_tree().root)
	if not emotes_panel:
		var t = create_tween().set_parallel(true)
		t.tween_property(_bg, "color:a", 0.96, 0.35)
		t.tween_property(_content_root, "modulate:a", 1.0, 0.4)
		return

	emotes_panel.visible = false
	var orig_sprite = emotes_panel.get_node_or_null("Emote/AnimatedSprite2D")

	if orig_sprite:
		_clone_avatar = AnimatedSprite2D.new()
		_clone_avatar.sprite_frames = orig_sprite.sprite_frames
		_clone_avatar.animation = orig_sprite.animation
		_clone_avatar.play(orig_sprite.animation)
		var g = emotes_panel.get_global_rect()
		_clone_avatar.global_position = g.position + g.size * 0.5
		_clone_avatar.scale = Vector2(1.0, 1.0)
		add_child(_clone_avatar)

	await get_tree().process_frame
	var target = _avatar_panel.global_position + _avatar_panel.size * 0.5

	var tw = create_tween().set_parallel(true)
	tw.tween_property(_bg, "color:a", 0.96, 0.55).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	if _clone_avatar:
		tw.tween_property(_clone_avatar, "global_position", target, 0.55).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tw.tween_property(_clone_avatar, "scale", Vector2(0.85, 0.85), 0.55).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await tw.finished

	var tw2 = create_tween().set_parallel(true)
	if _clone_avatar:
		tw2.tween_property(_clone_avatar, "modulate:a", 0.0, 0.2)
	tw2.tween_property(_content_root, "modulate:a", 1.0, 0.3)

	if orig_sprite:
		# avatar_wrapper → child[1] = SubViewportContainer → child[0] = SubViewport
		var svc_node = _avatar_panel.get_child(1) if _avatar_panel.get_child_count() > 1 else null
		var svp2 = svc_node.get_child(0) if svc_node and svc_node.get_child_count() > 0 else null
		if svp2:
			var inner = AnimatedSprite2D.new()
			inner.sprite_frames = orig_sprite.sprite_frames
			inner.animation = "emote_1_idle"
			inner.play("emote_1_idle")
			inner.position = Vector2(22, 22) # Perfectly centered in 44x44
			inner.scale = Vector2(0.9, 0.9)
			svp2.add_child(inner)

	await tw2.finished
	if _clone_avatar:
		_clone_avatar.queue_free()
		_clone_avatar = null

func _find_node(target_name: String, node: Node) -> Node:
	if node.name == target_name:
		return node
	for child in node.get_children():
		var r = _find_node(target_name, child)
		if r:
			return r
	return null

# ──── Interactions ──────────────────────────────────────────────
func _on_duration_selected(mins: int) -> void:
	if _is_active: return
	_selected_duration = mins
	_refresh_pills()
	_update_clock(0.0, float(mins) * 60.0)

func _refresh_pills() -> void:
	for i in _duration_buttons.size():
		var btn: Button = _duration_buttons[i]
		btn.disabled = _is_active
		btn.modulate = Color(0.45, 1.0, 0.55) if DURATIONS[i] == _selected_duration else Color.WHITE

func _on_action_pressed() -> void:
	if _is_completed:
		# Add 5 of the corresponding crop to the inventory
		var crop_name = "tomato" if _plant_row_offset == 6 else "corn"
		for i in range(5):
			InventoryManager.add_collectable(crop_name)
		_is_completed = false
		_on_close_pressed()
	elif _is_active:
		FocusManager.abandon_focus()
	else:
		FocusManager.start_focus(_selected_duration)

func _on_close_pressed() -> void:
	if _is_active: return
	var ep = _find_node("EmotesPanel", get_tree().root)
	if ep: ep.visible = true
	var tw = create_tween().set_parallel(true)
	tw.tween_property(_content_root, "modulate:a", 0.0, 0.22)
	tw.tween_property(_bg, "color:a", 0.0, 0.28)
	await tw.finished
	queue_free()

# ──── FocusManager signals ──────────────────────────────────────
func _on_focus_started(_dur: int) -> void:
	_is_active = true
	_set_active_mode()

func _on_focus_tick(elapsed: float, total: float) -> void:
	_update_clock(elapsed, total)
	_progress_ring.progress = elapsed / total
	var p = elapsed / total
	_tree_sprite.frame = _plant_row_offset + (
		1 if p < 0.2 else
		2 if p < 0.4 else
		3 if p < 0.6 else
		4 if p < 0.8 else
		5
	)

func _on_focus_completed() -> void:
	_is_active = false
	_is_completed = true
	_tree_sprite.frame = _plant_row_offset + 5
	_countdown_label.text = "00:00"
	_progress_ring.progress = 1.0
	_status_label.text = "🎉 Your tree bloomed! Great focus!"
	_action_btn.text = "🎁 Collect and Close"
	_action_btn.disabled = false
	_close_btn.visible = false
	_duration_row.visible = false
	_refresh_pills()

func _on_focus_abandoned() -> void:
	_is_active = false
	_is_completed = false
	_tree_sprite.frame = _plant_row_offset + 0
	_countdown_label.text = "--:--"
	_status_label.text = "🥀 The tree has wilted..."
	_action_btn.text = "Try Again"
	_action_btn.disabled = false
	_duration_row.visible = true
	_close_btn.visible = true
	_refresh_pills()
	await get_tree().create_timer(3.0).timeout
	if is_instance_valid(self) and not _is_active:
		_set_idle_mode()

func _set_idle_mode() -> void:
	_is_active = false
	_is_completed = false
	_tree_sprite.frame = _plant_row_offset + 0
	_status_label.text = "Plant a tree and stay focused!\nAbandon = tree dies 🥀"
	_action_btn.text = "🌱 Start Growing"
	_action_btn.disabled = false
	_close_btn.visible = true
	_duration_row.visible = true
	_progress_ring.progress = 0.0
	_refresh_pills()
	_update_clock(0.0, float(_selected_duration) * 60.0)

func _set_active_mode() -> void:
	_tree_sprite.frame = _plant_row_offset + 1
	_status_label.text = "Stay focused! Your tree is growing..."
	_action_btn.text = "🗑️ Abandon"
	_action_btn.disabled = false
	_close_btn.visible = false
	_duration_row.visible = false

func _update_clock(elapsed: float, total: float) -> void:
	var rem = max(0.0, total - elapsed)
	_countdown_label.text = "%02d:%02d" % [int(rem) / 60, int(rem) % 60]
