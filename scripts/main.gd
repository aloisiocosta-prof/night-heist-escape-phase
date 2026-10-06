extends Control
## Buildable landing scene; the gameplay requirements remain in docs/BACKLOG.md.

func _ready() -> void:
	var panel := VBoxContainer.new()
	panel.position = Vector2(48, 48)
	panel.add_theme_constant_override("separation", 24)
	add_child(panel)
	var title := Label.new()
	title.text = "NIGHT HEIST: ESCAPE PHASE"
	title.add_theme_font_size_override("font_size", 36)
	panel.add_child(title)
	var description := Label.new()
	description.text = "Infiltre quatro pavimentos. Saqueie o cofre. Volte ao início.\nEsqueleto técnico v0.1.0 — gameplay em desenvolvimento."
	panel.add_child(description)
	var button := Button.new()
	button.text = "Ver missão"
	button.custom_minimum_size = Vector2(320, 64)
	panel.add_child(button)
	button.pressed.connect(func() -> void: description.text = "Missão: portas, escadas, câmeras, lasers e fuga cronometrada.\nConsulte o backlog para acompanhar a implementação.")
