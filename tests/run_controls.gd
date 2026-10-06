extends SceneTree
var failures: Array[String] = []
func _initialize() -> void:
	call_deferred("_run")
func check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
		push_error(message)
func _run() -> void:
	var controls := HeistControls.new()
	controls.path = "user://test-controls.cfg"
	controls.apply()
	check(InputMap.action_get_events("right").any(func(event: InputEvent) -> bool: return event is InputEventJoypadMotion and event.axis == JOY_AXIS_LEFT_X and event.axis_value > 0), "Native analog direction mapped")
	controls.capture("jump", "keyboard")
	var key := InputEventKey.new()
	key.pressed = true
	key.physical_keycode = KEY_D
	check(not controls.bind_event(key) and controls.keys.jump == KEY_SPACE, "Duplicate key rejected without breaking right movement")
	key.physical_keycode = KEY_J
	check(controls.bind_event(key), "Free keyboard key accepted")
	controls.mode = 3
	controls.deadzone = 0.3
	controls.save()
	var restored := HeistControls.new()
	restored.path = controls.path
	restored.load_settings()
	check(restored.keys.jump == KEY_J and restored.mode == 3 and is_equal_approx(restored.deadzone, 0.3), "Bindings and settings survive reload")
	restored.reset()
	check(restored.keys.jump == KEY_SPACE, "Reset restores native default bindings")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(controls.path))
	var game: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.controls.mode = 3
	game.start_run()
	await process_frame
	await physics_frame
	var touch := InputEventScreenTouch.new()
	touch.index = 0
	touch.pressed = true
	touch.position = game.stick.get_global_transform_with_canvas() * (HeistVirtualStick.CENTER + Vector2(40, 0))
	# Headless DisplayServer does not route screen-touch events; exercise the native callback.
	game.stick._input(touch)
	await physics_frame
	check(Input.is_action_pressed("right"), "Virtual stick presses movement through touch")
	var x: float = game.player.position.x
	for _frame in 8:
		await physics_frame
	check(game.player.position.x > x, "Touch input actually moves CharacterBody2D")
	touch = touch.duplicate()
	touch.pressed = false
	game.stick._input(touch)
	await physics_frame
	check(not Input.is_action_pressed("right"), "Touch release clears movement")
	game._toggle_pause()
	check(not Input.is_action_pressed("right") and game.player.frozen, "Pause clears virtual input")
	game._open_settings()
	check(game.paused, "Opening settings keeps mission paused")
	game._settings_back()
	check(not game.paused, "Leaving settings resumes mission")
	game.queue_free()
	await process_frame
	await create_timer(0.1).timeout
	print("PASS: controls, persistence, duplicates, native touch and menu state" if failures.is_empty() else "FAIL: controls")
	quit(0 if failures.is_empty() else 1)
