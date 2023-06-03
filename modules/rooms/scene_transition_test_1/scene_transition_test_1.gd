class_name SceneTransitionTest1
extends Node2D


const RoomsManager = preload("res://modules/rooms_manager/rooms_manager.tscn")

@export var test_area_data : Area

@onready var map : TileMap = $Map
@onready var default_ui : DefaultUI = $DefaultUI
@onready var spawn_point_container : Node = $Map/SpawnPointContainer
@onready var default_spawn_point : PlayerSpawnPoint = $Map/SpawnPointContainer/DefaultSpawnPoint
@onready var test_area_entrance : Area2D = $Map/TestAreaEntrance
@onready var player_spawner : PlayerSpawner = $PlayerSpawner

func _ready():
	player_spawner.spawn_player()
	Game.camera.set_target(Game.player)
	

func _on_test_area_entrance_body_entered(body):
	test_area_entrance.get_node("CollisionShape2D").set_deferred("disabled", true)
	var rooms_manager = RoomsManager.instantiate()
	get_tree().root.add_child(rooms_manager)
	rooms_manager.start(test_area_data, "from_left")
