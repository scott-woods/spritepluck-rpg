extends Node2D


@onready var enemy_spawner : EnemySpawner = $EnemySpawner
@onready var combat_manager : CombatManager = $CombatManager
@onready var player_spawner : PlayerSpawner = $PlayerSpawner
@onready var map : TileMap = $Map

var room_data : DungeonRoomData = DungeonRoomData.new()

func init(data : DungeonRoomData):
	if data:
		room_data = data
