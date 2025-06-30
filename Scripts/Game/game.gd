extends Node2D

@onready var token_tile_map: Node = $TokenTileMap

var next_level_index: int = 1
var current_levelinfo: LevelInfo

func _ready():
	token_tile_map.connect("solved", _on_level_completed)
	
func _on_level_completed():
	if current_levelinfo and current_levelinfo.game_level:
		Levels.set_completed(current_levelinfo.num)
	change_level(next_level_index)


func change_level(level: int):
	remove_child(token_tile_map)
	token_tile_map.queue_free()
	current_levelinfo = Levels.get_level(level)
	next_level_index = level + 1
	if not current_levelinfo:
		return
	print(Levels.get_completion_status(current_levelinfo.num))
	var next_level_tile_map = current_levelinfo.tiles.instantiate()
	if next_level_tile_map.has_signal("level_selected"):
		next_level_tile_map.connect("level_selected", change_level)
	if next_level_tile_map.has_signal("solved"):
		next_level_tile_map.connect("solved", _on_level_completed)
	add_child(next_level_tile_map)
	token_tile_map = next_level_tile_map
