extends Node2D


signal combat_ended

@export var Player : PackedScene
@export var enemy_scene : PackedScene

@onready var map = $Map
@onready var combat_manager : CombatManager = $CombatManager
@onready var combat_ui = $CombatUI
@onready var camera = $Camera
@onready var enemy_spawn_marker : Marker2D = $EnemySpawnMarker
@onready var player_spawn_marker : Marker2D = $PlayerSpawnMarker

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = Player.instantiate()
	player.position = player_spawn_marker.position
	map.add_child(player)
	
	camera.set_target(player, true)
	
	combat_manager.setup(player, combat_ui, camera, map)
	combat_manager.combat_ended.connect(_on_combat_manager_combat_ended)
	
	combat_ui.setup(player, combat_manager)

func _unhandled_input(event):
	if event.is_action_pressed("tab"):
		if combat_manager.in_combat == false:
			var new_enemy = enemy_scene.instantiate()
			new_enemy.init(player)
			new_enemy.global_position = enemy_spawn_marker.global_position
			map.add_child(new_enemy)
			start_combat()

func start_combat():
	combat_ui.show()
	combat_manager.start_combat()

func end_combat():
	combat_ui.hide()


func _on_combat_manager_combat_ended():
	end_combat()
