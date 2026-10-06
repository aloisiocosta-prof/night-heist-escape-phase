class_name HeistMission
extends RefCounted
## Pure mission rules. No renderer, input, or audio dependencies.
signal finished(success: bool)
signal alerted
const DURATION := 180.0
const ALARM_PENALTY := 8.0
var status := "ready"
var remaining := DURATION
var loot := false
var loot_value := 0
var alarms := 0
var alarm_cooldown := 0.0
var elapsed := 0.0

func start() -> void:
	status = "running"

func tick(delta: float) -> void:
	if status != "running":
		return
	elapsed += delta
	alarm_cooldown = maxf(0.0, alarm_cooldown - delta)
	remaining = maxf(0.0, remaining - delta)
	if remaining <= 0.0:
		finish(false)

func collect_vault() -> void:
	if status == "running" and not loot:
		loot = true
		loot_value += 5000

func return_to_spawn(at_spawn: bool) -> void:
	if status == "running" and loot and at_spawn:
		finish(remaining > 0.0)

func alarm() -> void:
	if status != "running" or alarm_cooldown > 0.0:
		return
	alarms += 1
	alarm_cooldown = 3.0
	remaining = maxf(0.0, remaining - ALARM_PENALTY)
	alerted.emit()
	if remaining <= 0.0:
		finish(false)

func finish(success: bool) -> void:
	status = "won" if success else "failed"
	finished.emit(success)
