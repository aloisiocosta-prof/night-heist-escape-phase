extends SceneTree
var failures: Array[String] = []

func _initialize() -> void:
	call_deferred("_run")

func check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
		push_error(message)

func _run() -> void:
	var mission := HeistMission.new()
	mission.tick(12.0)
	check(mission.remaining == 180.0, "Timer must stay stopped on title screen")
	mission.start()
	mission.tick(2.0)
	check(is_equal_approx(mission.remaining, 178.0), "Timer counts from mission start")
	mission.return_to_spawn(true)
	check(mission.status == "running", "Returning without vault must never win")
	mission.alarm()
	check(mission.alarms == 1 and mission.remaining == 170.0, "Alarm applies one 8-second penalty")
	mission.alarm()
	check(mission.alarms == 1, "Alarm cooldown prevents repeated frame penalties")
	mission.collect_vault()
	mission.collect_vault()
	check(mission.loot_value == 5000, "Vault can only be collected once")
	mission.return_to_spawn(false)
	check(mission.status == "running", "Vault alone must never win")
	mission.return_to_spawn(true)
	check(mission.status == "won", "Vault plus return before timeout wins")
	var expired := HeistMission.new()
	expired.start()
	expired.collect_vault()
	expired.tick(180.0)
	expired.return_to_spawn(true)
	check(expired.status == "failed", "Timeout takes priority over return")
	var game: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	await process_frame
	check(game.has_method("start_run"), "GDD game must expose a real startable mission")
	if game.has_method("start_run"):
		await _integration(game)
	game.queue_free()
	await process_frame
	await create_timer(0.1).timeout
	print("PASS: mission, route, physics, sensors, skill checks and audio" if failures.is_empty() else "FAIL: %d assertions" % failures.size())
	quit(0 if failures.is_empty() else 1)

func _integration(game: Node) -> void:
	game.start_run()
	var player: HeistPlayer = game.player
	var level: HeistLevel = game.level
	var mission: HeistMission = game.mission
	await physics_frame
	var paused_time := mission.remaining
	game._toggle_pause()
	game._physics_process(2.0)
	check(mission.remaining == paused_time and player.frozen, "Pause stops timer and character")
	game._toggle_pause()
	player.position = Vector2(250, 600)
	player.velocity = Vector2.ZERO
	await physics_frame
	Input.action_press("jump")
	for _frame in 12:
		await physics_frame
	Input.action_release("jump")
	check(player.position.y < 585.0, "Jump lifts the native character above the floor")
	player.position = HeistLevel.SPAWN
	player.velocity = Vector2.ZERO
	check(level.interactions.size() == 6 and level.cameras.size() == 2 and level.lasers.size() == 2, "Four-floor scene must contain GDD interactions and security")
	check(not level.on_ladder(Vector2(1140, 550)), "Ground switch locks first ladder")
	level.activate(level.interactions[0])
	check(level.on_ladder(Vector2(1140, 550)), "Ground switch opens first ladder")
	player.position = Vector2(374, 600)
	Input.action_press("right")
	for _frame in 24:
		await physics_frame
	Input.action_release("right")
	check(player.position.x < 390.0, "Locked entry door physically blocks movement")
	game.begin_skill(level.interactions[1])
	game.skill_phase = 0.5
	check(game.skill_ui.get_parent() == game.ui, "Skill check must render above the level in the CanvasLayer")
	game.confirm_skill()
	check(level.interactions[1].open, "Skill check inside green interval opens door")
	Input.action_press("right")
	for _frame in 30:
		await physics_frame
	Input.action_release("right")
	check(player.position.x > 425.0, "Opened door permits traversal")
	player.position = Vector2(1140, 596)
	player.velocity = Vector2.ZERO
	Input.action_press("up")
	for _frame in 74:
		await physics_frame
	Input.action_release("up")
	check(player.position.y < 463.0, "Native ladder climbing reaches next floor")
	Input.action_press("down")
	for _frame in 85:
		await physics_frame
	Input.action_release("down")
	check(is_equal_approx(player.position.y, 600.0), "Descending ladder stops at lower floor instead of falling through it")
	player.position = Vector2(140, 456)
	level.activate(level.interactions[2])
	check(level.on_ladder(Vector2(140, 400)), "Upper switch opens second ladder")
	Input.action_press("up")
	for _frame in 85:
		await physics_frame
	Input.action_release("up")
	check(is_equal_approx(player.position.y, 312.0), "Second ladder reaches laser floor")
	player.position = Vector2(1140, 312)
	Input.action_press("up")
	for _frame in 85:
		await physics_frame
	Input.action_release("up")
	check(is_equal_approx(player.position.y, 168.0), "Third ladder reaches vault floor")
	Input.action_press("down")
	for _frame in 85:
		await physics_frame
	Input.action_release("down")
	check(is_equal_approx(player.position.y, 312.0), "Vault ladder returns to laser floor")
	player.position = Vector2(419, 312)
	game.begin_skill(level.interactions[3])
	game.skill_phase = 0.1
	game.confirm_skill()
	check(not level.interactions[3].open and level.interactions[3].cooldown > 0.0, "Missed skill check keeps door locked and adds cooldown")
	level.clock = 0.0
	player.position = Vector2(890, 312)
	player.crouched = false
	check(level.laser_hit(level.lasers[1], player), "Standing player intersects low laser")
	player.crouched = true
	check(not level.laser_hit(level.lasers[1], player), "Crouched player clears low laser")
	level.activate(level.interactions[4])
	check(not level.laser_active(level.lasers[0]), "Terminal temporarily disables lasers")
	level.security_disabled = 0.0
	mission.alarm_cooldown = 0.0
	var alarms_before: int = mission.alarms
	player.position = Vector2(600, 456)
	level.clock = 0.0
	level.sensor_tick(0.3, player)
	check(mission.alarms == alarms_before, "Camera does not alarm at 0.3s exposure")
	level.sensor_tick(0.21, player)
	check(mission.alarms == alarms_before + 1, "Camera alarms beyond 0.5s continuous exposure")
	level.activate(level.interactions[5])
	check(mission.loot, "Vault interaction collects objective")
	check(game.sound.streams.has("click") and game.sound.streams.has("step"), "Original audio cues loaded")
	mission.return_to_spawn(true)
	check(mission.status == "won", "Full objective sequence can win")
