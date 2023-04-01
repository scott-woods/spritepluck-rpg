extends Node2D


@export var Player : PackedScene
@export var test_area_data : Resource

@onready var map : TileMap = $Map
@onready var default_ui : DefaultUI = $DefaultUI
@onready var spawn_point_container : Node = $Map/SpawnPointContainer
@onready var default_spawn_point : PlayerSpawnPoint = $Map/SpawnPointContainer/DefaultSpawnPoint
@onready var test_area_entrance : Area2D = $Map/TestAreaEntrance

var player : Player
var camera : Camera

func _ready():
	camera = Game.camera
	player = Game.player
	start()

func start():
	spawn_player()
	camera.set_target(player, true)

func spawn_player():
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


func _on_test_area_entrance_body_entered(body):
	test_area_entrance.get_node("CollisionShape2D").set_deferred("disabled", true)
	RoomsManager.start(test_area_data, "from_left")
