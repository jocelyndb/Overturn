class_name TokenTileMapLayer
extends TileMapLayer


signal solved

var token_coords: Dictionary[Vector2i, TokenButton] = {}

func _enter_tree():
	child_entered_tree.connect(_register_token)
	#child_exiting_tree.connect(_unregister_token)
	
func _register_token(token: Node):
	await token.ready
	var coords = local_to_map(to_local(token.global_position))
	token_coords[coords] = token as TokenButton
	
func get_token_scene(coords: Vector2i) -> TokenButton:
	return token_coords.get(coords, null) as TokenButton
		
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R:
			reset_tokens()
		elif event.keycode == KEY_M:
			AudioManager.toggle_mute()
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:			
			var mapCoord: Vector2i = local_to_map(make_canvas_position_local(event.global_position))
			var token: TokenButton = get_token_scene(mapCoord)
			if token:
				token.flip()
				await get_tree().create_timer(0.14).timeout
				for neighbourOffset in token.neighbourOffsets:
					if get_token_scene(neighbourOffset + mapCoord):
						await get_tree().create_timer(0.04).timeout
						get_token_scene(neighbourOffset + mapCoord).flip()
				# Check if won
				if token_coords.values().all(func(level_token: TokenButton): return level_token.flipped):
					endgame()


func reset_tokens(flip_all: bool = false) -> void:
	for token: TokenButton in token_coords.values() :
		if flip_all or token.flipped:
			await get_tree().create_timer(randf_range(.01, 0.02)).timeout
			token.flip()

func endgame() -> void:
	print("Won!")
	await get_tree().create_timer(0.5).timeout
	reset_tokens()
	await get_tree().create_timer(0.5).timeout
	reset_tokens(true)
	await get_tree().create_timer(0.5).timeout
	reset_tokens()
	await get_tree().create_timer(0.5).timeout
	reset_tokens(true)
	solved.emit()
