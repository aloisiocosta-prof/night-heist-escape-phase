class_name HeistSound
extends Node
## Original deterministic synthesized PCM assets; no external library/recording.
const RATE := 22050
var streams: Dictionary = {}
var players: Array[AudioStreamPlayer] = []
var music := AudioStreamPlayer.new()
var muted := false

func _ready() -> void:
	["jump", "switch", "unlock", "loot", "alarm", "win", "fail", "step", "climb"].map(_make_effect)
	streams["click"] = preload("res://assets/audio/kenney/click_001.ogg")
	streams["hover"] = preload("res://assets/audio/kenney/open_001.ogg")
	streams["unlock"] = preload("res://assets/audio/kenney/confirmation_001.ogg")
	range(5).map(func(_i: int) -> void:
		var voice := AudioStreamPlayer.new()
		voice.volume_db = -14.0
		add_child(voice)
		players.append(voice))
	add_child(music)
	music.volume_db = -25.0
	music.stream = _make_music()

func play(cue: String) -> void:
	if muted or not streams.has(cue):
		return
	var idle := players.filter(func(p: AudioStreamPlayer) -> bool: return not p.playing)
	var voice: AudioStreamPlayer = idle.front() if not idle.is_empty() else players.front()
	voice.stream = streams[cue]
	voice.play()

func start_music() -> void:
	music.play()
	music.stream_paused = muted

func toggle_mute() -> void:
	muted = not muted
	music.stream_paused = muted

func _exit_tree() -> void:
	players.map(func(voice: AudioStreamPlayer) -> void:
		voice.stop()
		voice.stream = null)
	music.stop()
	music.stream = null

func _make_effect(cue: String) -> void:
	var tones: Dictionary = {"jump": [220, 440], "switch": [440, 660], "unlock": [330, 440, 660], "loot": [523, 659, 784], "alarm": [880, 440, 880, 440], "win": [523, 659, 784, 1046], "fail": [330, 247, 165], "step": [90], "climb": [160, 200]}
	streams[cue] = _wave(tones[cue], 0.11, false)

func _make_music() -> AudioStreamWAV:
	return _wave([110, 0, 165, 0, 131, 0, 165, 0, 98, 0, 147, 0, 110, 0, 147, 0], 0.3, true)

func _wave(notes: Array, duration: float, looped: bool) -> AudioStreamWAV:
	var samples := PackedByteArray()
	var count := int(duration * RATE)
	samples.resize(notes.size() * count * 2)
	# PCM synthesis needs indexed buffer writes: no native waveform equivalent.
	for n in notes.size():
		for i in count:
			var t := float(i) / RATE
			var envelope := minf(1.0, t * 80.0) * maxf(0.0, 1.0 - t / duration)
			var tone := sin(TAU * float(notes[n]) * t) + sin(TAU * float(notes[n]) * 2.0 * t) * 0.22
			samples.encode_s16((n * count + i) * 2, int(tone * envelope * 6500.0))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = RATE
	stream.data = samples
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD if looped else AudioStreamWAV.LOOP_DISABLED
	stream.loop_end = notes.size() * count
	return stream

func set_volumes(music_level: float, effects_level: float) -> void:
	music.volume_db = linear_to_db(maxf(music_level, 0.0001)) - 20.0
	players.map(func(voice: AudioStreamPlayer) -> void: voice.volume_db = linear_to_db(maxf(effects_level, 0.0001)) - 10.0)
