extends Node

const SAVE_PATH = "user://completed.save"

@export var levels_resource: LevelArray
@export var level_select: LevelInfo

@onready var levels: Array[LevelInfo] = levels_resource.levels
@onready var completed: Dictionary[int, bool] = (func() -> Dictionary[int, bool]:
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not save_file:
		return {}

	var parsed = JSON.parse_string(save_file.get_line())
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}

	var typed_dict: Dictionary[int, bool] = {}
	for key in parsed.keys():
		var int_key := int(key)
		var bool_value := bool(parsed[key])
		typed_dict[int_key] = bool_value
	return typed_dict).call()

func get_level(num: int) -> LevelInfo:
	if num < 0 or num > levels.size():
		return level_select
	return levels[num - 1]
	
func set_completed(num: int) -> bool:
	# set dummy value as no sets exist in GDScript
	completed[num] = true
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	return save_file.store_line(JSON.stringify(completed))
	
	
func get_completion_status(num: int) -> bool:
	return completed.has(num)

func get_levels() -> Array[LevelInfo]:
	return levels
