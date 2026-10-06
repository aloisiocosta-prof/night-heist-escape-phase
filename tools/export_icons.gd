extends SceneTree
func _initialize() -> void:
	[["night-heist", "icon-192", 192], ["night-heist", "icon-512", 512], ["adaptive-foreground", "adaptive-foreground", 432], ["adaptive-background", "adaptive-background", 432]].map(func(item: Array) -> void:
		var image: Image = load("res://assets/icons/%s.svg" % item[0]).get_image()
		image.resize(item[2], item[2], Image.INTERPOLATE_LANCZOS)
		image.save_png("res://assets/icons/%s.png" % item[1]))
	quit()
