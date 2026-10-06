extends SceneTree
## Run under Xvfb with Compatibility/OpenGL for a real engine screenshot.
func _initialize() -> void:
	call_deferred("_capture")
func _capture() -> void:
	var game: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.start_run()
	await create_timer(0.15).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/tmp/night-heist-gameplay.png")
	game._show_overlay("NIGHT HEIST", "ESCAPE PHASE\n\nInvada, saqueie e escape.\n\nQuatro pavimentos · Câmeras · Lasers · Skill checks\nTeclado e controles touch", "INICIAR", game.start_run)
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/tmp/night-heist-title.png")
	game.queue_free()
	await process_frame
	quit()
