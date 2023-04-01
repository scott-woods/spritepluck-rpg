class_name EnemySpawner
extends Node


@export var map : TileMap
@export var spawn_points_container : Node2D
@export var god_mode : bool

func spawn_enemies(enemy_types : Array[PackedScene]):
	var enemies : Array
	if god_mode:
		var random_enemy = enemy_types[randi_range(0, enemy_types.size() - 1)]
		var enemy = random_enemy.instantiate()
		var rand_point = spawn_points_container.get_children()[randi_range(0, spawn_points_container.get_child_count() - 1)]
		enemy.position = rand_point.position
		enemy.init(Game.player)
		map.add_child(enemy)
		enemies.append(enemy)
		return enemies
	for point in spawn_points_container.get_children():
		var random_enemy = enemy_types[randi_range(0, enemy_types.size() - 1)]
		var enemy = random_enemy.instantiate()
		enemy.position = point.position
		enemy.init(Game.player)
		map.add_child(enemy)
		enemies.append(enemy)
	return enemies
