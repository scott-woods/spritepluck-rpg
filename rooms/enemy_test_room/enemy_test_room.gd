extends Node2D


const Player = preload("res://entities/player/player.tscn")

@export var enemy_scene : PackedScene

@onready var tilemap = $TileMap
@onready var combat_manager : CombatManager = $CombatManager
@onready var combat_ui = $UI/CombatUI
@onready var camera = $Camera
@onready var utilities = $TileMap/Utilities
@onready var enemies = $TileMap/Enemies
@onready var enemy_spawn_marker : Marker2D = $EnemySpawnMarker
@onready var player_spawn_marker : Marker2D = $PlayerSpawnMarker

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = Player.instantiate()
	player.init(utilities, combat_ui, camera)
	player.global_position = player_spawn_marker.global_position
	tilemap.add_child(player)
	combat_manager.init(player, enemies, utilities, combat_ui, camera, tilemap)
	camera.set_target(player, true)
	combat_ui.init(player)

func _unhandled_input(event):
	if event.is_action_pressed("tab"):
		if combat_manager.in_combat == false:
			var new_enemy = enemy_scene.instantiate()
			new_enemy.init(player)
			new_enemy.global_position = enemy_spawn_marker.global_position
			enemies.add_child(new_enemy)
			combat_manager.start_combat()
