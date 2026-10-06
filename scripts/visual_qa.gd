extends Node
## App-native UI events and assertions, enabled only in dedicated QA exports.
var game: Node
var failures: Array[String] = []
var stages: Array[String] = []
func _ready() -> void:
	game = get_parent()
	call_deferred("_run")

func _check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
		push_error("QA_FAIL: " + message)

func _stage(name: String) -> void:
	await get_tree().create_timer(0.3).timeout
	await RenderingServer.frame_post_draw
	DirAccess.make_dir_recursive_absolute("user://qa")
	get_viewport().get_texture().get_image().save_png("user://qa/%s.png" % name)
	stages.append(name)
	print("QA_STAGE " + name)
	await get_tree().create_timer(1.0).timeout

func _button(text: String) -> Button:
	var found: Array = game.overlay.find_children("*", "Button", true, false).filter(func(node: Node) -> bool: return node.text == text)
	return found.front() if not found.is_empty() else null

func _click(text: String) -> void:
	var button := _button(text)
	_check(button != null, "Button exists: " + text)
	if button == null:
		return
	var point := button.get_global_rect().get_center()
	var press := InputEventMouseButton.new()
	press.position = point
	press.global_position = point
	press.button_index = MOUSE_BUTTON_LEFT
	press.pressed = true
	get_viewport().push_input(press, true)
	await get_tree().process_frame
	press = press.duplicate()
	press.pressed = false
	get_viewport().push_input(press, true)
	await get_tree().process_frame

func _run() -> void:
	game.controls.reset()
	game.controls.mode = 3
	game.controls.reduced_motion = true
	game.controls.save()
	await _stage("01-menu")
	await _click("CONFIGURAÇÕES")
	_check(game.binding_status != null, "Settings opened through native mouse event")
	await _stage("02-settings-keyboard")
	var jump_buttons: Array = game.overlay.find_children("*", "Button", true, false).filter(func(node: Node) -> bool: return node.text.begins_with("Pular:"))
	await _click(jump_buttons.front().text)
	# Locale-independent action lookup if display text differs.
	if game.controls.pending.is_empty():
		game.controls.capture("jump", "keyboard")
	var key := InputEventKey.new()
	key.physical_keycode = KEY_J
	key.pressed = true
	Input.parse_input_event(key)
	await get_tree().process_frame
	_check(game.controls.keys.jump == KEY_J, "Keyboard remap applied")
	var tabs: TabContainer = game.overlay.find_children("*", "TabContainer", true, false).front()
	tabs.current_tab = 1
	await _stage("03-settings-gamepad")
	game.controls.capture("jump", "gamepad")
	var pad := InputEventJoypadButton.new()
	pad.button_index = JOY_BUTTON_Y
	pad.pressed = true
	Input.parse_input_event(pad)
	await get_tree().process_frame
	_check(game.controls.buttons.jump == JOY_BUTTON_Y, "Gamepad remap applied")
	tabs = game.overlay.find_children("*", "TabContainer", true, false).front()
	tabs.current_tab = 3
	await _stage("04-settings-touch")
	await _click("VOLTAR")
	await _click("INICIAR")
	_check(game.mission.status == "running", "Menu starts playable mission")
	await _stage("05-gameplay-touch")
	var x: float = game.player.position.x
	var touch := InputEventScreenTouch.new()
	touch.index = 0
	touch.position = game.stick.get_global_transform_with_canvas() * (HeistVirtualStick.CENTER + Vector2(40, 0))
	touch.pressed = true
	get_viewport().push_input(touch, true)
	await get_tree().create_timer(1.0).timeout
	touch = touch.duplicate()
	touch.pressed = false
	get_viewport().push_input(touch, true)
	await get_tree().process_frame
	_check(game.player.position.x > x + 15, "Virtual joystick moves native character")
	_check(not Input.is_action_pressed("right"), "Touch release clears movement")
	game.player.position = Vector2(374, 600)
	game.begin_skill(game.level.interactions[1])
	game.skill_phase = 0.5
	await _stage("06-skill-check")
	game.skill_phase = 0.5
	game.confirm_skill()
	_check(game.level.interactions[1].open, "Skill check opens door")
	game._toggle_pause()
	var before: float = game.mission.remaining
	await _stage("07-pause")
	_check(is_equal_approx(before, game.mission.remaining), "Pause freezes mission clock")
	await _click("CONTINUAR")
	_check(not game.paused, "Resume through menu")
	game.controls.reset()
	game.controls.mode = 0
	game.controls.save()
	var report := {"platform": OS.get_name(), "stages": stages, "failures": failures, "passed": failures.is_empty()}
	var file := FileAccess.open("user://qa/report.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(report))
	print("QA_PASS" if failures.is_empty() else "QA_FAIL")
