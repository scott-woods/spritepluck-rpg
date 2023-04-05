class_name NPCTestRoom
extends Node2D


@onready var player_spawner : PlayerSpawner = $PlayerSpawner

func _ready():
	player_spawner.spawn_player()
	Game.camera.set_target(Game.player)
