class_name PlayerSpawner
extends Node


@export var spawn_points_container : Node2D
@export var map : TileMap

func spawn_player():
	var player = Game.player
	map.add_child(player)
	
	if spawn_points_container:
		if spawn_points_container.get_child_count() > 0:
			for point in spawn_points_container.get_children():
				point = point as PlayerSpawnPoint
				if point.spawn_id == SceneManager.current_spawn_point:
					player.position = point.position
					return
	
	print("No valid spawn point found, spawning at default position.")
	player.postion = Vector2.ZERO
