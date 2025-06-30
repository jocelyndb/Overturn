extends Node2D

@onready var levels_button: Button = $LevelsButton
@onready var mute_button: TextureButton = $MuteButton
@onready var game: Node2D = $Game
func _ready():
	levels_button.pressed.connect(func (): game.change_level(-1))
	mute_button.pressed.connect(func (): 
		AudioManager.toggle_mute()
		mute_button.texture_normal = load("res://Assets/Sprites/ui/mute_on.png") if AudioManager.muted else load("res://Assets/Sprites/ui/mute_off.png"))
