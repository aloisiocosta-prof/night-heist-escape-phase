class_name HeistControls
extends RefCounted
signal changed
const PATH := "user://controls.cfg"
const KEYS := {"left": KEY_A, "right": KEY_D, "up": KEY_W, "down": KEY_S, "jump": KEY_SPACE, "crouch": KEY_C, "run": KEY_SHIFT, "interact": KEY_E, "pause": KEY_ESCAPE, "restart": KEY_R}
const PAD := {"jump": JOY_BUTTON_A, "interact": JOY_BUTTON_X, "crouch": JOY_BUTTON_B, "run": JOY_BUTTON_LEFT_SHOULDER, "pause": JOY_BUTTON_START}
var path := PATH
var keys := KEYS.duplicate()
var buttons := PAD.duplicate()
var mouse := {"interact": MOUSE_BUTTON_LEFT, "jump": MOUSE_BUTTON_RIGHT}
var mode := 0
var deadzone := 0.22
var touch_scale := 1.0
var touch_opacity := 0.85
var music_volume := 0.65
var effects_volume := 0.8
var reduced_motion := false
var pending := ""
var binding_device := "keyboard"

func load_settings() -> void:
	var config := ConfigFile.new()
	if config.load(path) == OK:
		keys = config.get_value("controls", "keys", KEYS.duplicate())
		buttons = config.get_value("controls", "buttons", PAD.duplicate())
		mouse = config.get_value("controls", "mouse", mouse)
		["mode", "deadzone", "touch_scale", "touch_opacity", "music_volume", "effects_volume", "reduced_motion"].map(func(key: String) -> void: set(key, config.get_value("settings", key, get(key))))
	apply()

func save() -> void:
	var config := ConfigFile.new()
	["keys", "buttons", "mouse"].map(func(key: String) -> void: config.set_value("controls", key, get(key)))
	["mode", "deadzone", "touch_scale", "touch_opacity", "music_volume", "effects_volume", "reduced_motion"].map(func(key: String) -> void: config.set_value("settings", key, get(key)))
	config.save(path)
	changed.emit()

func apply() -> void:
	KEYS.keys().map(func(action: String) -> void:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		InputMap.action_erase_events(action)
		InputMap.action_set_deadzone(action, deadzone)
		var key := InputEventKey.new()
		key.physical_keycode = keys.get(action, KEYS[action])
		InputMap.action_add_event(action, key))
	{"left": KEY_LEFT, "right": KEY_RIGHT, "up": KEY_UP, "down": KEY_DOWN}.keys().map(func(action: String) -> void:
		var key := InputEventKey.new()
		key.physical_keycode = {"left": KEY_LEFT, "right": KEY_RIGHT, "up": KEY_UP, "down": KEY_DOWN}[action]
		InputMap.action_add_event(action, key)
		var axis := InputEventJoypadMotion.new()
		axis.axis = JOY_AXIS_LEFT_X if action in ["left", "right"] else JOY_AXIS_LEFT_Y
		axis.axis_value = -1.0 if action in ["left", "up"] else 1.0
		InputMap.action_add_event(action, axis)
		var button := InputEventJoypadButton.new()
		button.button_index = {"left": JOY_BUTTON_DPAD_LEFT, "right": JOY_BUTTON_DPAD_RIGHT, "up": JOY_BUTTON_DPAD_UP, "down": JOY_BUTTON_DPAD_DOWN}[action]
		InputMap.action_add_event(action, button))
	buttons.keys().map(func(action: String) -> void:
		var button := InputEventJoypadButton.new()
		button.button_index = buttons[action]
		InputMap.action_add_event(action, button))
	mouse.keys().map(func(action: String) -> void:
		var event := InputEventMouseButton.new()
		event.button_index = mouse[action]
		InputMap.action_add_event(action, event))

func capture(action: String, device: String) -> void:
	pending = action
	binding_device = device

func bind_event(event: InputEvent) -> bool:
	if pending.is_empty():
		return false
	var valid: bool = event is InputEventKey and event.pressed and not event.echo if binding_device == "keyboard" else event is InputEventJoypadButton and event.pressed if binding_device == "gamepad" else event is InputEventMouseButton and event.pressed
	if not valid:
		return false
	var collection: Dictionary = {"keyboard": keys, "gamepad": buttons, "mouse": mouse}[binding_device]
	var code: int = (event.physical_keycode if event.physical_keycode != 0 else event.keycode) if event is InputEventKey else event.button_index
	# Reject duplicate bindings within a device; preserve existing actions.
	if collection.keys().any(func(action: String) -> bool: return action != pending and collection[action] == code):
		return false
	collection[pending] = code
	pending = ""
	apply()
	save()
	return true

func reset() -> void:
	keys = KEYS.duplicate()
	buttons = PAD.duplicate()
	mouse = {"interact": MOUSE_BUTTON_LEFT, "jump": MOUSE_BUTTON_RIGHT}
	pending = ""
	apply()
	save()

func release_all() -> void:
	KEYS.keys().map(func(action: String) -> void: Input.action_release(action))

func hint(action: String) -> String:
	return {JOY_BUTTON_A: "A", JOY_BUTTON_B: "B", JOY_BUTTON_X: "X", JOY_BUTTON_Y: "Y", JOY_BUTTON_LEFT_SHOULDER: "LB", JOY_BUTTON_START: "START"}.get(buttons.get(action, 0), "PAD %d" % buttons.get(action, 0)) if mode == 2 else "TOQUE" if mode == 3 else OS.get_keycode_string(keys.get(action, KEY_E))
