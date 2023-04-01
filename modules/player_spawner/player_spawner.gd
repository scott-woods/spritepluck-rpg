class_name PlayerSpawner
extends Node


@export var spawn_points_container : Node2D
@export var map : TileMap

func spawn_player():
	Game.player.reparent(map)
	for point in spawn_points_container.get_children():
		point = point as PlayerSpawnPoint
		if point.spawn_id == SceneManager.current_spawn_point:
			Game.player.position = point.position
			return
	Game.player.position = Vector2.ZERO
