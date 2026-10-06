extends SceneTree
func _initialize() -> void:
	call_deferred("_capture")
func _capture() -> void:
	var game: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/tmp/night-heist-title.png")
	game.start_run()
	await create_timer(0.15).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/tmp/night-heist-gameplay.png")
	game.player.position = Vector2(374, 600)
	game.begin_skill(game.level.interactions[1])
	game.skill_phase = 0.5
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/tmp/night-heist-skill.png")
	game.queue_free()
	await process_frame
	await create_timer(0.1).timeout
	quit()
