class_name TestAreaBossRoom
extends Node2D


@onready var player_spawner : PlayerSpawner = $PlayerSpawner

var room_data : DungeonRoomData = DungeonRoomData.new()

func init(data : DungeonRoomData):
	if data:
		room_data = data

# Called when the node enters the scene tree for the first time.
func _ready():
	player_spawner.spawn_player()
	Game.camera.set_target(Game.player)
