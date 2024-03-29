class_name Room
extends Node2D


@onready var map : TileMap = $Map
@onready var spawn_point_container : Node = $Map/SpawnPointContainer
@onready var default_spawn_point : PlayerSpawnPoint = $Map/SpawnPointContainer/DefaultSpawnPoint

var player : Player
var camera : Camera

func _ready():
	start()
	
func start():
	pass

func spawn_player():
	player = Game.player
	var spawn_position = default_spawn_point.position
	if SceneManager.current_spawn_point:
		for spawn in spawn_point_container.get_children():
			if spawn.spawn_id == SceneManager.current_spawn_point:
				spawn_position = spawn.position
				break
	player.reparent(map, false)
	player.position = spawn_position
	if SceneManager.transitioning:
		player.state_machine.change_state("PlayerIdle")
		await SceneManager.scene_change_finished
	player.state_machine.change_state("PlayerMove")
	
	
func _on_player_utility_dropped(utility : Utility):
	map.add_child(utility)
