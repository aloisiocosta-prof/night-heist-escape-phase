class_name HeistPlayer
extends CharacterBody2D
const SPEED := 180.0
const RUN_SPEED := 265.0
const CLIMB_SPEED := 135.0
const JUMP_SPEED := -355.0
const GRAVITY := 1050.0
var level: Node2D
var frozen := true
var crouched := false
var facing := 1.0
var animation_time := 0.0
var feedback_time := 0.0
var feedback: Callable
var collider := CollisionShape2D.new()
var visual := Sprite2D.new()

func _ready() -> void:
	collision_layer = 4
	collision_mask = 3
	var rectangle := RectangleShape2D.new()
	rectangle.size = Vector2(20, 32)
	collider.shape = rectangle
	collider.position.y = -16
	add_child(collider)
	visual.texture = preload("res://assets/characters/thief.svg")
	visual.hframes = 10
	visual.position = Vector2(0, -24)
	visual.scale = Vector2(1.5, 1.5)
	visual.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(visual)
	floor_snap_length = 5.0

func _physics_process(delta: float) -> void:
	if frozen:
		velocity = Vector2.ZERO
		return
	animation_time += delta
	crouched = Input.is_action_pressed("crouch") or Input.is_action_pressed("down") and not level.on_ladder(position)
	var ladder: bool = level.on_ladder(position)
	var climb := Input.get_axis("up", "down")
	var climbing: bool = ladder and (climb != 0.0 or not is_on_floor())
	var bounds: Vector2 = level.ladder_bounds(position)
	set_collision_mask_value(1, not climbing)
	collider.shape.size.y = 18.0 if crouched else 32.0
	collider.position.y = -collider.shape.size.y * 0.5
	var axis := Input.get_axis("left", "right")
	var pace := RUN_SPEED if Input.is_action_pressed("run") else SPEED
	velocity.x = axis * (80.0 if crouched else pace)
	velocity.y = climb * CLIMB_SPEED if climbing else velocity.y + GRAVITY * delta
	if Input.is_action_just_pressed("jump") and (is_on_floor() or ladder) and not crouched:
		velocity.y = JUMP_SPEED
		set_collision_mask_value(1, true)
		climbing = false
	var was_airborne := not is_on_floor()
	move_and_slide()
	if climbing:
		position.y = clampf(position.y, bounds.x, bounds.y)
	position.x = clampf(position.x, 52.0, 1228.0)
	facing = signf(axis) if axis != 0.0 else facing
	visual.flip_h = facing < 0.0
	var frames := [1, 2, 3, 2] if axis != 0.0 else [0, 6]
	visual.frame = 7 + int(animation_time * 7) % 2 if climbing else 5 if crouched else 9 if not is_on_floor() and velocity.y > 0 else 4 if not is_on_floor() else frames[int(animation_time * (11.0 if axis != 0.0 else 2.0)) % frames.size()]
	feedback_time = maxf(0.0, feedback_time - delta)
	if feedback_time == 0.0 and feedback.is_valid() and (climbing and climb != 0.0 or is_on_floor() and axis != 0.0):
		feedback.call("climb" if climbing else "step")
		feedback_time = 0.28 if Input.is_action_pressed("run") else 0.42
	if was_airborne and is_on_floor() and feedback.is_valid():
		feedback.call("step")
	visual.position.y = -15.0 if crouched else -24.0
	visual.scale.y = 0.9 if crouched else 1.5
