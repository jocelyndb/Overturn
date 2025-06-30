class_name TokenTileMapLayer
extends TileMapLayer


signal solved

var token_coords: Dictionary[Vector2i, TokenButton] = {}

func _enter_tree():
	child_entered_tree.connect(_register_token)
	child_exiting_tree.connect(_unregister_token)
	
func _register_token(token: Node):
	await token.ready
	AudioManager.play("tink", 0.2)
	var coords = local_to_map(to_local(token.global_position))
	#print(token.global_position)
	token_coords[coords] = token as TokenButton
	token.set_meta("token_coords", coords)
	
func _unregister_token(token: Node):
	token_coords.erase(token.get_meta("tile_cords"))
	
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
				AudioManager.play("tink", 1.2)
				await get_tree().create_timer(0.14).timeout
				for neighbourOffset in token.neighbourOffsets:
					if get_token_scene(neighbourOffset + mapCoord):
						AudioManager.play("tink", 1.1)
						await get_tree().create_timer(0.04).timeout
						get_token_scene(neighbourOffset + mapCoord).flip()
				# Check if won
				if token_coords.values().all(func(token: TokenButton): return token.flipped):
					endgame()


func reset_tokens() -> void:
	for token: TokenButton in token_coords.values() :
		if token.flipped:
			token.flip()
			AudioManager.play("tink", 0.2)
			#await get_tree().create_timer(randf_range(.00, 0.02)).timeout
			

func endgame() -> void:
	await get_tree().create_timer(0.5).timeout
	print("Won!")
	reset_tokens()
	AudioManager.play("tink", 0.3, 0.01)
	await get_tree().create_timer(0.5).timeout
	token_coords.values().all(func(token: TokenButton): 
		token.flip()
		return true)
	AudioManager.play("tink", 0.3)
	AudioManager.play("tink", 0.3, 0.01)
	AudioManager.play("tink", 0.3, 0.02)
	await get_tree().create_timer(0.5).timeout
	reset_tokens()
	AudioManager.play("tink", 0.3, 0.01)
	await get_tree().create_timer(0.5).timeout
	token_coords.values().all(func(token: TokenButton): 
		token.flip()
		return true)
	solved.emit()
		
