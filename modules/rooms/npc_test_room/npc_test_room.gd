class_name NPCTestRoom
extends Node2D


@onready var default_ui : DefaultUI = $DefaultUI
@onready var player_spawner : PlayerSpawner = $PlayerSpawner

func _ready():
	player_spawner.spawn_player()
	Game.camera.set_target(Game.player)
	
	var interactables = get_tree().get_nodes_in_group("interactables")
	default_ui.setup(interactables)
