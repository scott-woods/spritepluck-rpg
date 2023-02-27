extends Node2D


@export var Player : PackedScene

@onready var map : TileMap = $Map
@onready var default_ui : DefaultUI = $DefaultUI
@onready var camera : Camera = $Camera
@onready var spawn_point_container : Node = $Map/SpawnPointContainer
@onready var default_spawn_point : PlayerSpawnPoint = $Map/SpawnPointContainer/DefaultSpawnPoint

var player : Player

func _ready():
	player = Player.instantiate()
	var spawn_position = default_spawn_point.position
	if SceneManager.current_spawn_point:
		for spawn in spawn_point_container.get_children():
			if spawn.spawn_id == SceneManager.current_spawn_point:
				spawn_position = spawn.position
				break
	player.position = spawn_position
	map.add_child(player)
	
	camera.set_target(player, true)
