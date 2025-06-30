extends GridContainer

signal level_selected(num: int)

var token_button = preload("res://Scenes/Token/token.tscn")

func _ready():
	for level in Levels.get_levels():
		var button: TokenButton = token_button.instantiate()
		var text = Label.new()
		text.text = str(level.num)
		text.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
		button.add_child(text)
		print("Button size: ", button.size)
		button.pressed.connect(func (): 
			level_selected.emit(level.num))
		add_child(button)
		text.set("theme_override_colors/font_color", Color(.835, .835, .835))
		if Levels.get_completion_status(level.num):
			printt("Flipping", level.num)
			button.flip()
			text.set("theme_override_colors/font_color", Color(0.1254901961,0.1254901961,0.1254901961))
	
