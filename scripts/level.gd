class_name HeistLevel
extends Node2D
const FLOORS := [600.0, 456.0, 312.0, 168.0]
const LADDER_X := [1140.0, 140.0, 1140.0]
const SPAWN := Vector2(88, 600)
const WALL := Color("4a4d52")
const YELLOW := Color("eab308")
const RED := Color("ef4444")
const GREEN := Color("4ade80")
var mission: HeistMission
var interactions: Array[Dictionary] = []
var cameras: Array[Dictionary] = []
var lasers: Array[Dictionary] = []
var gates := [false, false, true]
var loot_items := [Vector2(370, 430), Vector2(810, 430), Vector2(885, 142)]
var security_disabled := 0.0
var clock := 0.0

func _ready() -> void:
	range(4).map(func(i: int) -> void: _solid(Rect2(40, FLOORS[i], 1200, 12), 1))
	_solid(Rect2(28, 72, 12, 540), 1)
	_solid(Rect2(1240, 72, 12, 540), 1)
	_add_interaction("ground", "switch", Vector2(185, 580))
	_add_interaction("entry", "door", Vector2(410, 600))
	_add_interaction("trapdoor", "switch", Vector2(925, 436))
	_add_interaction("inner", "door", Vector2(455, 312))
	_add_interaction("terminal", "hack", Vector2(785, 292))
	_add_interaction("vault", "vault", Vector2(185, 143))
	cameras = [{"origin": Vector2(600, 356), "phase": 0.0, "exposure": 0.0}, {"origin": Vector2(680, 68), "phase": 2.5, "exposure": 0.0}]
	lasers = [{"a": Vector2(580, 254), "b": Vector2(625, 305), "phase": 0.0}, {"a": Vector2(840, 285), "b": Vector2(940, 285), "phase": 1.4}]

func _solid(rect: Rect2, layer: int) -> StaticBody2D:
	var body := StaticBody2D.new()
	body.collision_layer = layer
	body.collision_mask = 4
	body.position = rect.position
	var shape := CollisionShape2D.new()
	var box := RectangleShape2D.new()
	box.size = rect.size
	shape.shape = box
	shape.position = rect.size * 0.5
	body.add_child(shape)
	add_child(body)
	return body

func _add_interaction(id: String, kind: String, point: Vector2) -> void:
	var item := {"id": id, "kind": kind, "pos": point, "open": false, "cooldown": 0.0}
	if kind == "door":
		item["body"] = _solid(Rect2(point - Vector2(13, 116), Vector2(26, 116)), 2)
	interactions.append(item)

func on_ladder(point: Vector2) -> bool:
	return range(3).any(func(i: int) -> bool: return gates[i] and absf(point.x - LADDER_X[i]) < 24.0 and point.y >= FLOORS[i + 1] - 6.0 and point.y <= FLOORS[i] + 6.0)

func ladder_bounds(point: Vector2) -> Vector2:
	var nearby := range(3).filter(func(i: int) -> bool: return gates[i] and absf(point.x - LADDER_X[i]) < 24.0 and point.y >= FLOORS[i + 1] - 6.0 and point.y <= FLOORS[i] + 6.0)
	return Vector2(FLOORS[nearby[0] + 1], FLOORS[nearby[0]]) if not nearby.is_empty() else Vector2(point.y, point.y)

func target(point: Vector2) -> Dictionary:
	var nearby := interactions.filter(func(item: Dictionary) -> bool: return point.distance_to(item.pos) < 66.0 and not item.open)
	nearby.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return point.distance_squared_to(a.pos) < point.distance_squared_to(b.pos))
	return nearby.front() if not nearby.is_empty() else {}

func open_door(id: String) -> void:
	var found := interactions.filter(func(item: Dictionary) -> bool: return item.id == id)
	if found.is_empty():
		return
	found[0].open = true
	found[0].body.set_collision_layer_value(2, false)
	queue_redraw()

func activate(item: Dictionary) -> void:
	var handlers := {"switch": _switch, "hack": _hack, "vault": _vault}
	if handlers.has(item.kind):
		handlers[item.kind].call(item)

func _switch(item: Dictionary) -> void:
	item.open = true
	gates[0 if item.id == "ground" else 1] = true

func _hack(_item: Dictionary) -> void:
	security_disabled = 12.0

func _vault(item: Dictionary) -> void:
	item.open = true
	mission.collect_vault()

func sensor_tick(delta: float, player: HeistPlayer) -> void:
	clock += delta
	security_disabled = maxf(0.0, security_disabled - delta)
	interactions.map(func(item: Dictionary) -> void: item.cooldown = maxf(0.0, item.cooldown - delta))
	cameras.map(func(camera: Dictionary) -> void:
		var visible := security_disabled <= 0.0 and Geometry2D.is_point_in_polygon(player.position - Vector2(0, 16), camera_cone(camera))
		camera.exposure = camera.exposure + delta if visible else 0.0
		if camera.exposure > 0.5:
			mission.alarm())
	lasers.map(func(laser: Dictionary) -> void:
		if laser_active(laser) and laser_hit(laser, player):
			mission.alarm())
	var collected := loot_items.filter(func(point: Vector2) -> bool: return point.distance_to(player.position - Vector2(0, 16)) < 28.0)
	mission.loot_value += collected.size() * 250
	loot_items = loot_items.filter(func(point: Vector2) -> bool: return not collected.has(point))
	queue_redraw()

func camera_cone(camera: Dictionary) -> PackedVector2Array:
	var center: Vector2 = camera.origin + Vector2(sin(clock * 0.8 + camera.phase) * 115.0, 100)
	return PackedVector2Array([camera.origin, center + Vector2(-92, 0), center + Vector2(92, 0)])

func laser_active(laser: Dictionary) -> bool:
	return security_disabled <= 0.0 and fmod(clock + laser.phase, 3.5) < 2.0

func laser_hit(laser: Dictionary, player: HeistPlayer) -> bool:
	# Segment vs player's inset rectangle, so crouching actually clears low beams.
	var height := 18.0 if player.crouched else 32.0
	var rect := Rect2(player.position - Vector2(9, height), Vector2(18, height - 2))
	var a: Vector2 = laser.a
	var b: Vector2 = laser.b
	return rect.has_point(a) or rect.has_point(b) or Geometry2D.segment_intersects_segment(a, b, rect.position, rect.position + Vector2(rect.size.x, 0)) != null or Geometry2D.segment_intersects_segment(a, b, rect.position + Vector2(0, rect.size.y), rect.end) != null or Geometry2D.segment_intersects_segment(a, b, rect.position, rect.position + Vector2(0, rect.size.y)) != null or Geometry2D.segment_intersects_segment(a, b, rect.position + Vector2(rect.size.x, 0), rect.end) != null

func _draw() -> void:
	_draw_city()
	range(4).map(_draw_floor)
	range(3).map(_draw_ladder)
	interactions.map(_draw_interaction)
	cameras.map(func(camera: Dictionary) -> void:
		draw_colored_polygon(camera_cone(camera), Color(0.91, 0.70, 0.03, 0.12 if security_disabled <= 0.0 else 0.025))
		draw_rect(Rect2(camera.origin - Vector2(12, 5), Vector2(24, 10)), WALL.lightened(0.4))
		draw_circle(camera.origin + Vector2(0, 4), 3, RED if camera.exposure > 0.0 else YELLOW))
	lasers.map(func(laser: Dictionary) -> void:
		draw_line(laser.a, laser.b, Color(1, 0.15, 0.25, 0.15), 6)
		draw_line(laser.a, laser.b, RED if laser_active(laser) else Color("3e3345"), 2)
		draw_rect(Rect2(laser.a - Vector2(5, 5), Vector2(10, 10)), WALL))
	loot_items.map(func(point: Vector2) -> void:
		draw_rect(Rect2(point - Vector2(6, 7), Vector2(12, 14)), YELLOW)
		draw_rect(Rect2(point - Vector2(3, 4), Vector2(6, 8)), Color("fff3b0")))
	draw_rect(Rect2(62, 568, 52, 32), Color(0.29, 0.87, 0.50, 0.15))
	draw_line(Vector2(62, 598), Vector2(114, 598), GREEN, 3)
	draw_string(ThemeDB.fallback_font, Vector2(62, 561), "FUGA", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, GREEN)

func _draw_city() -> void:
	draw_rect(Rect2(0, 0, 1280, 720), Color("080f20"))
	draw_circle(Vector2(1095, 88), 40, Color("c4d9e2"))
	draw_circle(Vector2(1110, 75), 35, Color("080f20"))
	range(18).map(func(i: int) -> void:
		var height := 70 + (i * 43) % 155
		draw_rect(Rect2(i * 78, 630 - height, 66, height), Color("111d32")))
	draw_rect(Rect2(36, 68, 1208, 545), Color("172235"))
	range(4).map(func(floor_id: int) -> void:
		range(12).map(func(i: int) -> void:
			var point := Vector2(65 + i * 99, FLOORS[floor_id] - 100)
			draw_rect(Rect2(point, Vector2(60, 67)), Color("0c1528"))
			draw_rect(Rect2(point + Vector2(2, 2), Vector2(25, 28)), Color("1c3144"))
			draw_line(point + Vector2(30, 0), point + Vector2(30, 67), WALL, 2)))

func _draw_floor(i: int) -> void:
	var y: float = FLOORS[i]
	draw_rect(Rect2(40, y, 1200, 12), WALL)
	draw_rect(Rect2(40, y, 1200, 3), Color("7c8793"))
	draw_rect(Rect2(40, y + 12, 1200, 5), Color("0b1425"))
	draw_string(ThemeDB.fallback_font, Vector2(47, y - 102), ["00 / ENTRADA", "01 / VIGILÂNCIA", "02 / LASERS", "03 / COFRE"][i], HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color("648099"))

func _draw_ladder(i: int) -> void:
	var x: float = LADDER_X[i]
	var top: float = FLOORS[i + 1]
	var bottom: float = FLOORS[i]
	var tint := Color("8b5a2b") if gates[i] else Color("4a3433")
	draw_line(Vector2(x - 15, top - 5), Vector2(x - 15, bottom), tint, 5)
	draw_line(Vector2(x + 15, top - 5), Vector2(x + 15, bottom), tint, 5)
	range(10).map(func(n: int) -> void: draw_line(Vector2(x - 15, top + n * 15), Vector2(x + 15, top + n * 15), tint, 3))
	if not gates[i]:
		draw_rect(Rect2(x - 22, top - 4, 44, 8), RED)

func _draw_interaction(item: Dictionary) -> void:
	var p: Vector2 = item.pos
	var draw_handlers := {"door": _draw_door, "switch": _draw_switch, "hack": _draw_terminal, "vault": _draw_vault}
	draw_handlers[item.kind].call(p, item.open)

func _draw_door(p: Vector2, opened: bool) -> void:
	draw_rect(Rect2(p - Vector2(14, 116), Vector2(28, 116)), Color("2b3741") if opened else Color("8b5a2b"))
	draw_rect(Rect2(p - Vector2(10, 110), Vector2(20, 103)), Color("172235") if opened else Color("5d3d26"))
	draw_circle(p - Vector2(6, 48), 3, GREEN if opened else YELLOW)

func _draw_switch(p: Vector2, opened: bool) -> void:
	draw_rect(Rect2(p - Vector2(13, 12), Vector2(26, 24)), WALL)
	draw_rect(Rect2(p - Vector2(7, 7), Vector2(14, 14)), GREEN if opened else RED)

func _draw_terminal(p: Vector2, _opened: bool) -> void:
	draw_rect(Rect2(p - Vector2(21, 25), Vector2(42, 30)), WALL)
	draw_rect(Rect2(p - Vector2(17, 21), Vector2(34, 20)), Color("132e38"))
	draw_line(p - Vector2(12, 12), p + Vector2(11, -12), GREEN, 2)
	draw_rect(Rect2(p + Vector2(-25, 8), Vector2(50, 10)), Color("8b5a2b"))

func _draw_vault(p: Vector2, opened: bool) -> void:
	draw_rect(Rect2(p - Vector2(30, 44), Vector2(60, 69)), Color("798592"))
	draw_rect(Rect2(p - Vector2(25, 39), Vector2(50, 59)), Color("182c3a") if opened else Color("3f4e5c"))
	draw_arc(p + Vector2(0, -9), 15, 0, TAU, 16, GREEN if opened else YELLOW, 3)
	draw_line(p + Vector2(-15, -9), p + Vector2(15, -9), YELLOW, 2)
