extends Node2D


@onready var player_spawner : PlayerSpawner = $PlayerSpawner

var room_data : DungeonRoomData = DungeonRoomData.new()

func init(data : DungeonRoomData):
	room_data = data
