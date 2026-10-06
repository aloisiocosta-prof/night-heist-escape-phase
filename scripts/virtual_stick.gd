class_name HeistVirtualStick
extends Control
var pointer := -2
var direction := Vector2.ZERO
var radius := 49.0
const CENTER := Vector2(72, 62)

func _ready() -> void:
	custom_minimum_size = Vector2(144, 120)
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if event is InputEventScreenTouch:
		if event.pressed and pointer == -2 and _local(event.position).distance_to(CENTER) <= radius * 1.35:
			pointer = event.index
			_move(_local(event.position))
			get_viewport().set_input_as_handled()
		elif not event.pressed and event.index == pointer:
			release()
			get_viewport().set_input_as_handled()
	elif event is InputEventScreenDrag and event.index == pointer:
		_move(_local(event.position))
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and pointer == -2 and _local(event.position).distance_to(CENTER) <= radius * 1.35:
			pointer = -1
			_move(_local(event.position))
			get_viewport().set_input_as_handled()
		elif not event.pressed and pointer == -1:
			release()
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion and pointer == -1:
		_move(_local(event.position))

func _local(point: Vector2) -> Vector2:
	return get_global_transform_with_canvas().affine_inverse() * point

func _move(point: Vector2) -> void:
	direction = ((point - CENTER) / radius).limit_length()
	{"left": -direction.x, "right": direction.x, "up": -direction.y, "down": direction.y}.keys().map(func(action: String) -> void:
		var strength: float = {"left": -direction.x, "right": direction.x, "up": -direction.y, "down": direction.y}[action]
		if strength > 0.2:
			Input.action_press(action, strength)
		else:
			Input.action_release(action))
	queue_redraw()

func release() -> void:
	pointer = -2
	direction = Vector2.ZERO
	["left", "right", "up", "down"].map(func(action: String) -> void: Input.action_release(action))
	queue_redraw()

func _draw() -> void:
	draw_circle(CENTER, radius + 10, Color(0.06, 0.11, 0.18, 0.8))
	draw_arc(CENTER, radius + 10, 0, TAU, 48, Color("5b8190"), 2, true)
	draw_line(CENTER - Vector2(36, 0), CENTER + Vector2(36, 0), Color("294658"), 2)
	draw_line(CENTER - Vector2(0, 36), CENTER + Vector2(0, 36), Color("294658"), 2)
	draw_circle(CENTER + direction * radius * 0.5, 24, Color("4ade80") if pointer != -2 else Color("284c5b"))
	draw_arc(CENTER + direction * radius * 0.5, 24, 0, TAU, 32, Color("93d8db"), 2, true)
