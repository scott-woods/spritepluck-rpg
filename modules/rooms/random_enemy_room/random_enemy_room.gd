class_name RandomEnemyRoom
extends Node2D


@export var Player : PackedScene
@export var FastEnemy : PackedScene
@export var Ranger : PackedScene
@export var TestEnemy : PackedScene

@onready var combat_manager : CombatManager = $CombatManager
@onready var tilemap : TileMap = $TileMap
@onready var combat_ui : CombatUI = $UI/CombatUI
@onready var camera : Camera = $Camera
@onready var utilities : Node = $TileMap/Utilities
@onready var enemies : Node = $TileMap/Enemies
@onready var top_left_spawn : Marker2D = $TopLeftSpawn
@onready var bottom_right_spawn : Marker2D = $BottomRightSpawn
@onready var player_spawn_marker : Marker2D = $PlayerSpawnMarker

@export var min_enemies : int
@export var max_enemies : int
@export var min_dist_from_player : int
@export var max_dist_from_player : int
@export var min_neighbor_distance : int

var player : Player
var enemy_types : Array

func _ready():
	init_enemy_type_array()
	player = Player.instantiate()
	player.init(utilities, combat_ui, camera)
	player.global_position = player_spawn_marker.position
	tilemap.add_child(player)
	combat_manager.init(player, enemies, utilities, combat_ui, camera, tilemap)
	camera.set_target(player, true)
	combat_ui.init(player)
	
func _unhandled_input(event):
	if event.is_action_pressed("tab"):
		if combat_manager.in_combat == false:
			var number_of_enemies = randi_range(min_enemies, max_enemies)
			while enemies.get_children().size() < number_of_enemies:
				var type = enemy_types[randi_range(0, enemy_types.size() - 1)]
				var enemy = type.instantiate()
				enemy.init(player)
				
				var pos : Vector2
				var can_continue = false
				while can_continue == false:
					pos.x = randi_range(top_left_spawn.position.x, bottom_right_spawn.position.x)
					pos.y = randi_range(top_left_spawn.position.y, bottom_right_spawn.position.y)
					can_continue = true
					for e in enemies.get_children():
						if pos.distance_to(e.position) < min_neighbor_distance:
							can_continue = false
							break
					
				enemy.global_position = pos
				enemies.add_child(enemy)
			combat_manager.start_combat()

func init_enemy_type_array():
	enemy_types.append(FastEnemy)
	enemy_types.append(Ranger)
	enemy_types.append(TestEnemy)
