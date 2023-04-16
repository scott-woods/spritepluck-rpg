extends Node2D


@export var enemy_scene : PackedScene

@onready var player_spawner : PlayerSpawner = $PlayerSpawner
@onready var enemy_spawn : Marker2D = $Map/EnemySpawn
@onready var map : TileMap = $Map
@onready var combat_manager : CombatManager = $CombatManager

func _ready():
	player_spawner.spawn_player()
	Game.camera.set_target(Game.player)
	
	combat_manager.start_combat()
