extends SceneTree
func _initialize() -> void:
	var config := ConfigFile.new()
	config.load("res://export_presets.cfg")
	[[0, 2, "Web QA", "build/qa-web/index.html"], [1, 3, "Android QA", "build/qa-android/night-heist-qa.apk"]].map(func(item: Array) -> void:
		["preset.%d" % item[0], "preset.%d.options" % item[0]].map(func(section: String) -> void:
			var target := section.replace("preset.%d" % item[0], "preset.%d" % item[1])
			Array(config.get_section_keys(section)).map(func(key: String) -> void: config.set_value(target, key, config.get_value(section, key))))
		config.set_value("preset.%d" % item[1], "name", item[2])
		config.set_value("preset.%d" % item[1], "custom_features", "visual_qa")
		config.set_value("preset.%d" % item[1], "export_path", item[3]))
	["armeabi-v7a", "arm64-v8a", "x86"].map(func(arch: String) -> void: config.set_value("preset.3.options", "architectures/" + arch, false))
	config.set_value("preset.3.options", "architectures/x86_64", true)
	config.save("res://export_presets.cfg")
	quit()
