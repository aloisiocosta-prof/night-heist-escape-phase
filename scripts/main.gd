extends Node2D
## Native Godot composition: mission rules, character physics, level, UI, and sound.
## game novo
var mission := HeistMission.new()
var level := HeistLevel.new()
var player := HeistPlayer.new()
var sound := HeistSound.new()
var controls := HeistControls.new()
var hud := Control.new()
var virtual_controls := Node2D.new()
var stick := HeistVirtualStick.new()
var settings_tab := 0
var binding_status: Label
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
	controls.load_settings()
	controls.changed.connect(_apply_settings)
	level.mission = mission
	add_child(level)
	player.level = level
	player.feedback = sound.play
	player.position = HeistLevel.SPAWN
	add_child(player)
	add_child(sound)
	add_child(ui)
	ui.add_child(hud)
	ui.add_child(skill_ui)
	skill_ui.draw.connect(_draw_skill)
	mission.finished.connect(_result)
	mission.alerted.connect(func() -> void:
		sound.play("alarm")
		tip_remaining = 2.8
		if not controls.reduced_motion:
			player.visual.modulate = HeistLevel.RED
			create_tween().tween_property(player.visual, "modulate", Color.WHITE, 0.35))
	_build_hud()
	_apply_settings()
	_show_main_menu()
	if OS.has_feature("visual_qa") or OS.get_cmdline_user_args().has("--visual-qa"):
		var qa := Node.new()
		qa.set_script(load("res://scripts/visual_qa.gd"))
		add_child(qa)
	skill_ui.queue_redraw()

func start_run() -> void:
	_close_overlay()
	controls.release_all()
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
	hud.visible = mission.status != "ready"
	virtual_controls.visible = mission.status == "running" and not paused and (controls.mode == 3 or controls.mode == 0 and DisplayServer.is_touchscreen_available())
	timer_label.text = "%02d:%02d" % [int(mission.remaining) / 60, int(mission.remaining) % 60]
	timer_label.modulate = HeistLevel.RED if mission.remaining < 30 else Color("d4e8f4")
	objective_label.text = "VOLTE À FUGA" if mission.loot else "ENCONTRE O COFRE / 03"
	status_label.text = "$ %d   |   ALARMES %d" % [mission.loot_value, mission.alarms]
	var nearby := level.target(player.position)
	var prompts := {"switch": "%s: abrir passagem", "door": "%s: arrombar porta", "hack": "%s: desativar segurança (12 s)", "vault": "%s: saquear cofre"}
	prompt_label.text = (prompts.get(nearby.get("kind", ""), "SUBA PELO LADO DIREITO" if not level.gates[0] else "CÂMERAS: evite o cone • LASERS: espere, pule ou agache")).replace("%s", controls.hint("interact"))
	if not nearby.is_empty() and nearby.cooldown > 0.0:
		prompt_label.text = "PORTA BLOQUEADA: %.1f s" % nearby.cooldown
	if not skill_target.is_empty():
		prompt_label.text = "SKILL CHECK: %s na zona verde" % controls.hint("interact")
	if tip_remaining > 0.0:
		prompt_label.text = "ALARME! −8 segundos • continue a missão"

func _input(event: InputEvent) -> void:
	if not controls.pending.is_empty():
		if event.is_action_pressed("ui_cancel"):
			controls.pending = ""
			_show_settings()
			get_viewport().set_input_as_handled()
			return
		var accepted := controls.bind_event(event)
		get_viewport().set_input_as_handled()
		if accepted:
			_show_settings()
		return

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart") and mission.status != "ready":
		_restart()
	if event.is_action_pressed("pause"):
		_toggle_pause()
	if event.is_action_pressed("interact") and not event is InputEventMouseButton:
		_interact()
	if event is InputEventMouseButton and event.is_action_pressed("interact"):
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
	stick.release()
	controls.release_all()
	paused = not paused
	player.frozen = paused or not skill_target.is_empty()
	sound.music.stream_paused = paused or sound.muted
	if paused:
		_show_overlay("MISSÃO PAUSADA", "O relógio está parado.\n\nE / toque: interagir e confirmar o skill check\nC: agachar sob o laser horizontal\nTerminais desligam a segurança por 12 segundos.\nColete o cofre no topo e retorne ao início.", "CONTINUAR", _toggle_pause)
		_overlay_button("CONFIGURAÇÕES", _show_settings)
		_overlay_button("MENU INICIAL", _return_to_menu)
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
	bar.size = Vector2(1280, 58)
	bar.color = Color("101b2d")
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud.add_child(bar)
	_label(objective_label, Vector2(28, 18), 20)
	_label(timer_label, Vector2(602, 10), 32)
	_label(status_label, Vector2(790, 20), 17)
	_label(prompt_label, Vector2(280, 618), 17)
	prompt_label.size = Vector2(710, 30)
	prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_button("PAUSA", Vector2(1090, 8), _toggle_pause, Vector2(90, 42))
	_button("AJUSTES", Vector2(1190, 8), _open_settings, Vector2(80, 42))
	hud.add_child(virtual_controls)
	virtual_controls.add_child(stick)
	var buttons := [["run", Vector2(812, 634), "CORRER"], ["crouch", Vector2(906, 634), "AGACHAR"], ["jump", Vector2(1002, 620), "PULAR"], ["interact", Vector2(1110, 620), "AÇÃO"]]
	buttons.map(func(entry: Array) -> void:
		var touch := TouchScreenButton.new()
		touch.position = entry[1]
		touch.texture_normal = load("res://assets/ui/%s.svg" % entry[0])
		touch.texture_pressed = touch.texture_normal
		touch.action = entry[0]
		touch.pressed.connect(func() -> void:
			touch.modulate = Color("4ade80")
			if entry[0] == "interact":
				_interact()
			if entry[0] == "jump":
				sound.play("jump"))
		touch.released.connect(func() -> void: touch.modulate = Color.WHITE)
		virtual_controls.add_child(touch)
		var caption := Label.new()
		caption.position = entry[1] + Vector2(-2, 70)
		caption.text = entry[2]
		caption.add_theme_font_size_override("font_size", 11)
		caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
		virtual_controls.add_child(caption))

func _label(label: Label, point: Vector2, font_size: int) -> void:
	label.position = point
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color("d4e8f4"))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud.add_child(label)

func _button(text: String, point: Vector2, callback: Callable, dimensions := Vector2(280, 54)) -> Button:
	var button := Button.new()
	button.text = text
	button.position = point
	button.size = dimensions
	button.add_theme_font_size_override("font_size", 18)
	button.pressed.connect(callback)
	hud.add_child(button)
	_style_button(button)
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
	_style_button(button)
	button.grab_focus()
	if not controls.reduced_motion:
		overlay.modulate.a = 0.0
		overlay.create_tween().tween_property(overlay, "modulate:a", 1.0, 0.18)

func _draw_skill() -> void:
	if skill_target.is_empty():
		return
	skill_ui.draw_rect(Rect2(430, 235, 420, 90), Color("0b1425"))
	skill_ui.draw_string(ThemeDB.fallback_font, Vector2(457, 258), "ARROMBAMENTO / %s PARA CONFIRMAR" % controls.hint("interact"), HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color.WHITE)
	skill_ui.draw_rect(Rect2(450, 278, 380, 22), Color("334155"))
	skill_ui.draw_rect(Rect2(450 + 380 * 0.4, 278, 380 * 0.22, 22), HeistLevel.GREEN)
	skill_ui.draw_line(Vector2(450 + 380 * skill_phase, 272), Vector2(450 + 380 * skill_phase, 307), Color.WHITE, 4)

func _style_button(button: Button) -> void:
	["normal", "hover", "pressed", "focus"].map(func(state: String) -> void:
		var style := StyleBoxFlat.new()
		style.bg_color = Color("244455") if state == "hover" else Color("17313e") if state == "pressed" else Color("162638")
		style.border_color = Color("4ade80") if state in ["hover", "focus"] else Color("426078")
		style.set_border_width_all(2)
		style.set_corner_radius_all(8)
		style.set_content_margin_all(10)
		button.add_theme_stylebox_override(state, style))
	button.mouse_entered.connect(func() -> void: sound.play("hover"))
	button.pressed.connect(func() -> void: sound.play("click"))

func _overlay_button(text: String, callback: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size.y = 44
	button.add_theme_font_size_override("font_size", 18)
	button.pressed.connect(callback)
	overlay.get_child(0).add_child(button)
	_style_button(button)
	return button

func _show_main_menu() -> void:
	_show_overlay("NIGHT HEIST", "ESCAPE PHASE / INFILTRAÇÃO NOTURNA\n\nQuatro pavimentos. Um cofre. Uma única saída.\nPlaneje a ida e a volta antes que o tempo acabe.", "INICIAR", start_run)
	_overlay_button("CONFIGURAÇÕES", _show_settings)
	_overlay_button("COMO JOGAR", _show_help)

func _show_help() -> void:
	_show_overlay("PLANO DE FUGA", "1. Ative o interruptor e arrombe a porta.\n2. Suba à direita; abra a segunda escada no piso 01.\n3. Atravesse os lasers e use o terminal.\n4. Saqueie o cofre e volte à área verde.\n\nWASD/setas: mover e subir • Espaço: salto • C: agachar\nShift: correr • E: ação • Esc: pausa\nGamepad: analógico/D-pad • A: salto • X: ação\nB: agachar • LB: correr • Start: pausa\nMouse: esquerdo ação • direito salto; teclado para mover.", "VOLTAR", _show_main_menu)

func _return_to_menu() -> void:
	controls.release_all()
	get_tree().reload_current_scene()

func _open_settings() -> void:
	if mission.status == "running" and not paused:
		_toggle_pause()
	_show_settings()

func _settings_back() -> void:
	controls.pending = ""
	controls.release_all()
	if mission.status == "ready":
		_show_main_menu()
	else:
		paused = true
		_toggle_pause()

func _apply_settings() -> void:
	sound.set_volumes(controls.music_volume, controls.effects_volume)
	virtual_controls.modulate.a = controls.touch_opacity
	stick.scale = Vector2.ONE * controls.touch_scale
	stick.position = Vector2(128, 660) - HeistVirtualStick.CENTER * controls.touch_scale

func _show_settings() -> void:
	if mission.status == "running" and not paused:
		_toggle_pause()
	_close_overlay()
	overlay = PanelContainer.new()
	overlay.position = Vector2(220, 78)
	overlay.size = Vector2(840, 550)
	var style := StyleBoxFlat.new()
	style.bg_color = Color("101d31")
	style.border_color = Color("426078")
	style.set_border_width_all(2)
	style.set_content_margin_all(20)
	style.set_corner_radius_all(10)
	overlay.add_theme_stylebox_override("panel", style)
	ui.add_child(overlay)
	var stack := VBoxContainer.new()
	overlay.add_child(stack)
	var title := Label.new()
	title.text = "CONFIGURAÇÕES / CONTROLES"
	title.add_theme_font_size_override("font_size", 26)
	stack.add_child(title)
	var profile := OptionButton.new()
	["Automático", "Teclado + mouse", "Gamepad", "Touch"].map(func(text: String) -> void: profile.add_item(text))
	profile.select(controls.mode)
	profile.item_selected.connect(func(index: int) -> void:
		controls.mode = index
		controls.save())
	stack.add_child(profile)
	var tabs := TabContainer.new()
	tabs.custom_minimum_size.y = 350
	stack.add_child(tabs)
	["Teclado", "Gamepad", "Mouse", "Touch", "Áudio"].map(func(name: String) -> void:
		var box := VBoxContainer.new()
		box.name = name
		tabs.add_child(box))
	var labels := {"left": "Esquerda", "right": "Direita", "up": "Subir", "down": "Descer", "jump": "Pular", "crouch": "Agachar", "run": "Correr", "interact": "Interagir", "pause": "Pausar", "restart": "Reiniciar"}
	[["keyboard", controls.keys, tabs.get_child(0)], ["gamepad", controls.buttons, tabs.get_child(1)], ["mouse", controls.mouse, tabs.get_child(2)]].map(func(device: Array) -> void:
		var grid := GridContainer.new()
		grid.columns = 2
		device[2].add_child(grid)
		device[1].keys().map(func(action: String) -> void:
			var button := Button.new()
			var name := OS.get_keycode_string(device[1][action]) if device[0] == "keyboard" else "Botão %d" % device[1][action]
			button.text = "%s: %s" % [labels[action], name]
			button.custom_minimum_size = Vector2(370, 42)
			button.pressed.connect(func() -> void:
				controls.capture(action, device[0])
				binding_status.text = "Pressione um comando livre para %s; comandos duplicados são rejeitados." % labels[action])
			_style_button(button)
			grid.add_child(button)))
	_slider(tabs.get_child(1), "Zona morta do analógico", "deadzone", 0.1, 0.5, 0.02)
	_slider(tabs.get_child(3), "Tamanho do joystick", "touch_scale", 0.8, 1.05, 0.05)
	_slider(tabs.get_child(3), "Opacidade", "touch_opacity", 0.35, 1.0, 0.05)
	_slider(tabs.get_child(4), "Música", "music_volume", 0.0, 1.0, 0.05)
	_slider(tabs.get_child(4), "Efeitos", "effects_volume", 0.0, 1.0, 0.05)
	var motion := CheckButton.new()
	motion.text = "Reduzir animações de interface"
	motion.button_pressed = controls.reduced_motion
	motion.toggled.connect(func(value: bool) -> void:
		controls.reduced_motion = value
		controls.save())
	tabs.get_child(4).add_child(motion)
	tabs.current_tab = settings_tab
	tabs.tab_changed.connect(func(index: int) -> void: settings_tab = index)
	binding_status = Label.new()
	binding_status.text = "Clique em uma ação para remapear; configurações são salvas automaticamente."
	binding_status.add_theme_font_size_override("font_size", 14)
	stack.add_child(binding_status)
	var reset := Button.new()
	reset.text = "RESTAURAR COMANDOS"
	reset.pressed.connect(func() -> void:
		controls.reset()
		_show_settings())
	_style_button(reset)
	stack.add_child(reset)
	var back := Button.new()
	back.text = "VOLTAR"
	back.custom_minimum_size.y = 44
	back.pressed.connect(_settings_back)
	_style_button(back)
	stack.add_child(back)
	back.grab_focus()

func _slider(parent: Node, caption: String, setting: String, low: float, high: float, step: float) -> void:
	var label := Label.new()
	label.text = caption
	parent.add_child(label)
	var slider := HSlider.new()
	slider.min_value = low
	slider.max_value = high
	slider.step = step
	slider.value = controls.get(setting)
	slider.value_changed.connect(func(value: float) -> void:
		controls.set(setting, value)
		controls.apply()
		controls.save())
	parent.add_child(slider)
