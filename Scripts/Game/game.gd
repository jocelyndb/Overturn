extends Node2D

@onready var token_tile_map: Node = $TokenTileMap

var next_level_index: int = 1
var current_levelinfo: LevelInfo

func _ready():
	token_tile_map.connect("solved", _on_level_completed)

#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:			
			#_on_level_completed()

func _on_level_completed():
	if current_levelinfo and current_levelinfo.game_level:
		Levels.set_completed(current_levelinfo.num)
	change_level(next_level_index)
		#add_child(levels[next_level_index].tiles.instantiate())


func change_level(level: int):
	# TODO: gracefully handle last level
	token_tile_map.queue_free()
	current_levelinfo = Levels.get_level(level)
	next_level_index = level + 1
	if not current_levelinfo:
		return
	print(Levels.get_completion_status(current_levelinfo.num))
	var next_level_tile_map = current_levelinfo.tiles.instantiate()
	if next_level_tile_map.has_signal("level_selected"):
		next_level_tile_map.connect("level_selected", change_level)
	add_child(next_level_tile_map)
	token_tile_map = next_level_tile_map
	token_tile_map.connect("solved", _on_level_completed)
