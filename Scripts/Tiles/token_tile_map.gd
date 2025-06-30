extends Node

@onready var tokens: TokenTileMapLayer = $Tokens
signal solved

func _ready() -> void:
	tokens.connect("solved", func (): solved.emit())
