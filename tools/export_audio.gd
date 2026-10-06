extends SceneTree
func _initialize() -> void:
	call_deferred("_export")
func _export() -> void:
	var sound := HeistSound.new()
	root.add_child(sound)
	await process_frame
	sound.streams.keys().map(func(key: String) -> void: sound.streams[key].save_to_wav("res://assets/audio/%s.wav" % key))
	sound.music.stream.save_to_wav("res://assets/audio/infiltration.wav")
	sound.queue_free()
	await process_frame
	quit()
