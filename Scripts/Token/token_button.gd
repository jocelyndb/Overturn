extends TextureButton

class_name TokenButton


#signal token_pressed(coords: Vector2i, neighbourCoords: Array[Vector2i])

@export var neighbourOffsets: Array[Vector2i] = [
	Vector2i(0,-1),
	Vector2i(1,0),
	Vector2i(0,1),
	Vector2i(-1,0),
]

@export var flipped = false

#@onready var tilemap: TileMapLayer = get_parent() as TileMapLayer
#@onready var tilemapCoords: Vector2i = tilemap.local_to_map(global_position)
#@onready var neighbourCoords = (neighbourOffsets.map(func(vec: Vector2i) -> Vector2i: return vec + tilemapCoords) as Array[Vector2i])
@onready var sprite: AnimatedSprite2D = $Sprite

func _ready() -> void:
	#material.set("shader_paramater/flipped", flipped);
	await get_tree().create_timer(randf_range(0.1,0.3)).timeout
	sprite.play(&"flip")

func flip() -> void:
	flipped = !flipped;
	if flipped:
		sprite.play_backwards(&"flip")
	else:
		sprite.play(&"flip")
	print("Flipped? ", flipped)
	#material.set("shader_parameter/flipped", flipped);
	#print(material.get("shader_parameter/flipped"))
	# TODO: animate flipping and change texture
	
