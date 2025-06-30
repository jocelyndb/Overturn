extends Node

@export_dir var sfx_directory
@export_file var bg_music
@export_range(0, 1) var bg_intensity: float
@export var mute_sfx_with_music: bool = false

@onready var bg_music_player: AudioStreamPlayer = addAudioStreamPlayer(bg_music)

var players: Dictionary[StringName, AudioStreamPlayer]
var muted: bool = false

func _ready():
	bg_music_player.volume_linear = bg_intensity
	bg_music_player.play()
	bg_music_player.finished.connect(bg_music_player.play)
	
	var dir = DirAccess.open(sfx_directory)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			elif file_name.get_extension() == "import":
				addAudioStreamPlayer(sfx_directory + "/" + file_name.replace(".import", ""))
				print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		
func addAudioStreamPlayer(file_path: String) -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.stream = load(file_path)
	player.max_polyphony = 3
	players[file_path.get_file().split(".")[0]] = player
	add_child(player)
	return player
	
func toggle_mute() -> void:
	muted = !muted
	bg_music_player.volume_linear = 0.0 if muted else bg_intensity

func play(file_name: StringName, intensity: float = 1.0, delay: float = 0) -> void:
	if mute_sfx_with_music:
		return
		
	var player = players.get(file_name) as AudioStreamPlayer
	if player:
		await get_tree().create_timer(delay).timeout
		player.volume_linear = intensity
		player.play()
