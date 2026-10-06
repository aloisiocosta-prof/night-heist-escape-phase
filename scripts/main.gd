extends Node2D
## Native Godot composition: mission rules, character physics, level, UI, and sound.
var mission := HeistMission.new()
var level := HeistLevel.new()
var player := HeistPlayer.new()
var sound := HeistSound.new()
var ui := CanvasLayer.new()
var skill_ui := Node2D.new()
var timer_label := Label.new()
var objective_label := Label.new()
var prompt_label := Label.new()
var status_label := Label.new()
var overlay: PanelContainer
var paused := false
var skill_target: Dictionary = {}
var skill_phase := 0.0
var skill_direction := 1.0
var tip_remaining := 0.0

func _ready() -> void:
	_setup_input()
	level.mission = mission
	add_child(level)
	player.level = level
	player.position = HeistLevel.SPAWN
	add_child(player)
	add_child(sound)
	add_child(ui)
	ui.add_child(skill_ui)
	skill_ui.draw.connect(_draw_skill)
	mission.finished.connect(_result)
	mission.alerted.connect(func() -> void:
		sound.play("alarm")
		tip_remaining = 2.8)
	_build_hud()
	_show_overlay("NIGHT HEIST", "ESCAPE PHASE\n\nInvada quatro pavimentos, abra o cofre e volte à área verde.\nA fuga faz parte do roubo. Você tem 180 segundos.\n\nA/D ou ←/→: mover  ·  W/S ou ↑/↓: escadas\nEspaço: pular  ·  Shift: correr  ·  C: agachar\nE: interagir / skill check  ·  Esc: pausar\n\nOs botões na borda também aceitam toque.", "INICIAR INFILTRAÇÃO", start_run)
	skill_ui.queue_redraw()

func _setup_input() -> void:
	var mapping := {"left": [KEY_A, KEY_LEFT], "right": [KEY_D, KEY_RIGHT], "up": [KEY_W, KEY_UP], "down": [KEY_S, KEY_DOWN], "jump": [KEY_SPACE], "crouch": [KEY_C], "run": [KEY_SHIFT], "interact": [KEY_E], "pause": [KEY_ESCAPE], "restart": [KEY_R]}
	mapping.keys().map(func(action: String) -> void:
		InputMap.add_action(action) if not InputMap.has_action(action) else null
		mapping[action].map(func(code: int) -> void:
			var event := InputEventKey.new()
			event.physical_keycode = code
			InputMap.action_add_event(action, event)))

func start_run() -> void:
	_close_overlay()
	mission.start()
	player.frozen = false
	sound.start_music()

func _physics_process(delta: float) -> void:
	if mission.status != "running" or paused:
		return
	mission.tick(delta)
	level.sensor_tick(delta, player)
	mission.return_to_spawn(player.position.distance_to(HeistLevel.SPAWN) < 30.0)
	tip_remaining = maxf(0.0, tip_remaining - delta)
	if not skill_target.is_empty():
		skill_phase += delta * skill_direction * 0.75
		if skill_phase >= 1.0 or skill_phase <= 0.0:
			skill_phase = clampf(skill_phase, 0.0, 1.0)
			skill_direction *= -1.0
	skill_ui.queue_redraw()

func _process(_delta: float) -> void:
	timer_label.text = "%02d:%02d" % [int(mission.remaining) / 60, int(mission.remaining) % 60]
	timer_label.modulate = HeistLevel.RED if mission.remaining < 30 else Color("d4e8f4")
	objective_label.text = "VOLTE À FUGA" if mission.loot else "ENCONTRE O COFRE / 03"
	status_label.text = "$ %d   |   ALARMES %d" % [mission.loot_value, mission.alarms]
	var nearby := level.target(player.position)
	var prompts := {"switch": "E / toque: abrir passagem", "door": "E / toque: arrombar porta", "hack": "E / toque: desativar segurança (12 s)", "vault": "E / toque: saquear cofre"}
	prompt_label.text = prompts.get(nearby.get("kind", ""), "SUBA PELO LADO DIREITO" if not level.gates[0] else "CÂMERAS: evite o cone • LASERS: espere, pule ou agache")
	if not nearby.is_empty() and nearby.cooldown > 0.0:
		prompt_label.text = "PORTA BLOQUEADA: %.1f s" % nearby.cooldown
	if not skill_target.is_empty():
		prompt_label.text = "SKILL CHECK: pressione E / toque na zona verde"
	if tip_remaining > 0.0:
		prompt_label.text = "ALARME! −8 segundos • continue a missão"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		_restart()
	if event.is_action_pressed("pause"):
		_toggle_pause()
	if event.is_action_pressed("interact"):
		_interact()
	if event.is_action_pressed("jump") and mission.status == "running" and not paused:
		sound.play("jump")

func _interact() -> void:
	if mission.status != "running" or paused:
		return
	if not skill_target.is_empty():
		confirm_skill()
		return
	var nearby := level.target(player.position)
	if nearby.is_empty() or nearby.cooldown > 0.0:
		return
	if nearby.kind == "door":
		begin_skill(nearby)
		return
	level.activate(nearby)
	sound.play({"switch": "switch", "hack": "switch", "vault": "loot"}.get(nearby.kind, "switch"))

func begin_skill(item: Dictionary) -> void:
	skill_target = item
	skill_phase = 0.0
	skill_direction = 1.0
	player.frozen = true

func confirm_skill() -> void:
	if skill_target.is_empty():
		return
	if skill_phase >= 0.4 and skill_phase <= 0.62:
		level.open_door(skill_target.id)
		sound.play("unlock")
	else:
		skill_target.cooldown = 2.0
		mission.alarm()
	skill_target = {}
	player.frozen = mission.status != "running"

func _toggle_pause() -> void:
	if mission.status != "running":
		return
	paused = not paused
	player.frozen = paused or not skill_target.is_empty()
	sound.music.stream_paused = paused or sound.muted
	if paused:
		_show_overlay("MISSÃO PAUSADA", "O relógio está parado.\n\nE / toque: interagir e confirmar o skill check\nC: agachar sob o laser horizontal\nTerminais desligam a segurança por 12 segundos.\nColete o cofre no topo e retorne ao início.", "CONTINUAR", _toggle_pause)
	else:
		_close_overlay()

func _result(success: bool) -> void:
	player.frozen = true
	sound.music.stop()
	sound.play("win" if success else "fail")
	var title := "FUGA CONCLUÍDA" if success else "TEMPO ESGOTADO"
	var body := "Saque: $ %d\nAlarmes: %d\nTempo restante: %.1f s\n\n%s" % [mission.loot_value, mission.alarms, mission.remaining, "Você trouxe o cofre de volta ao ponto de fuga." if success else "Planeje a ida e a volta. Use o terminal e observe os lasers."]
	_show_overlay(title, body, "TENTAR NOVAMENTE", _restart)

func _restart() -> void:
	["left", "right", "up", "down", "jump", "crouch", "run", "interact"].map(func(action: String) -> void: Input.action_release(action))
	get_tree().reload_current_scene()

func _close_overlay() -> void:
	if is_instance_valid(overlay):
		overlay.queue_free()

func _build_hud() -> void:
	var bar := ColorRect.new()
	bar.position = Vector2(0, 0)
	bar.size = Vector2(1280, 58)
	bar.color = Color("101b2d")
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(bar)
	_label(objective_label, Vector2(28, 18), 22)
	_label(timer_label, Vector2(610, 12), 30)
	_label(status_label, Vector2(790, 20), 18)
	_label(prompt_label, Vector2(250, 623), 18)
	prompt_label.size = Vector2(900, 30)
	prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_button("II", Vector2(1120, 8), _toggle_pause, Vector2(52, 42))
	_button("SOM", Vector2(1182, 8), sound.toggle_mute, Vector2(70, 42))
	var buttons := [
		["left", Vector2(25, 655)], ["right", Vector2(105, 655)],
		["up", Vector2(190, 655)], ["down", Vector2(270, 655)],
		["run", Vector2(755, 655)], ["crouch", Vector2(835, 655)],
		["jump", Vector2(920, 655)], ["interact", Vector2(1020, 655)]]
	buttons.map(func(entry: Array) -> void:
		var touch := TouchScreenButton.new()
		touch.position = entry[1]
		touch.texture_normal = load("res://assets/ui/%s.svg" % entry[0])
		touch.texture_pressed = touch.texture_normal
		touch.action = entry[0]
		touch.pressed.connect(func() -> void:
			touch.modulate = Color("4ade80")
			if entry[0] == "interact":
				_interact())
		touch.released.connect(func() -> void: touch.modulate = Color.WHITE)
		ui.add_child(touch))
	var hint := Label.new()
	hint.text = "A/D · W/S · SPACE · SHIFT · C · E"
	_label(hint, Vector2(380, 680), 12)
	hint.modulate = Color("648099")

func _label(label: Label, point: Vector2, font_size: int) -> void:
	label.position = point
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color("d4e8f4"))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(label)

func _button(text: String, point: Vector2, callback: Callable, dimensions := Vector2(280, 54)) -> Button:
	var button := Button.new()
	button.text = text
	button.position = point
	button.size = dimensions
	button.add_theme_font_size_override("font_size", 18)
	button.pressed.connect(callback)
	ui.add_child(button)
	return button

func _show_overlay(title: String, body: String, primary: String, callback: Callable) -> void:
	_close_overlay()
	overlay = PanelContainer.new()
	overlay.position = Vector2(300, 122)
	overlay.size = Vector2(680, 456)
	var style := StyleBoxFlat.new()
	style.bg_color = Color("101d31")
	style.border_color = Color("426078")
	style.set_border_width_all(2)
	style.set_content_margin_all(28)
	style.set_corner_radius_all(8)
	overlay.add_theme_stylebox_override("panel", style)
	ui.add_child(overlay)
	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 14)
	overlay.add_child(stack)
	var header := Label.new()
	header.text = title
	header.add_theme_font_size_override("font_size", 36)
	header.add_theme_color_override("font_color", Color("4ade80"))
	stack.add_child(header)
	var details := Label.new()
	details.text = body
	details.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	details.custom_minimum_size.x = 620
	details.add_theme_font_size_override("font_size", 18)
	stack.add_child(details)
	var button := Button.new()
	button.text = primary
	button.custom_minimum_size.y = 54
	button.add_theme_font_size_override("font_size", 20)
	button.pressed.connect(callback)
	stack.add_child(button)

func _draw_skill() -> void:
	if skill_target.is_empty():
		return
	skill_ui.draw_rect(Rect2(430, 235, 420, 90), Color("0b1425"))
	skill_ui.draw_string(ThemeDB.fallback_font, Vector2(457, 258), "ARROMBAMENTO / E PARA CONFIRMAR", HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color.WHITE)
	skill_ui.draw_rect(Rect2(450, 278, 380, 22), Color("334155"))
	skill_ui.draw_rect(Rect2(450 + 380 * 0.4, 278, 380 * 0.22, 22), HeistLevel.GREEN)
	skill_ui.draw_line(Vector2(450 + 380 * skill_phase, 272), Vector2(450 + 380 * skill_phase, 307), Color.WHITE, 4)
