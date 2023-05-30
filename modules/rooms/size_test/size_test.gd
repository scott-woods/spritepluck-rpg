extends Node2D


@onready var player : Player = $TileMap/Player

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.camera.set_target(player, true)
