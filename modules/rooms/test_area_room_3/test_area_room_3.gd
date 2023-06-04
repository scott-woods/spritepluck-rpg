class_name TestAreaRoom3
extends Node2D


@onready var enemy_spawner : EnemySpawner = $EnemySpawner
@onready var combat_manager : CombatManager = $CombatManager
@onready var player_spawner : PlayerSpawner = $PlayerSpawner
@onready var map : TileMap = $Map

var room_data : DungeonRoomData = DungeonRoomData.new()

func init(data : DungeonRoomData):
	if data:
		room_data = data

func _ready():	
	player_spawner.spawn_player()
	Game.player.utility_dropped.connect(_on_player_utility_dropped)
	Game.camera.set_target(Game.player)
	start()

func start():
	if SceneManager.transitioning:
		await SceneManager.scene_change_finished

	if room_data.room_cleared == false:
		combat_manager.start_combat()


func _on_player_utility_dropped(utility : Utility):
	map.add_child(utility)
