class_name RefactorRoom
extends Node2D


@export var Player : PackedScene
@export var TestEnemy : PackedScene
@export var FastEnemy : PackedScene
@export var Ranger : PackedScene

@onready var combat_manager : CombatManager = $CombatManager
@onready var map : TileMap = $Map
@onready var player_spawn_marker : Marker2D = $PlayerSpawnMarker
@onready var camera : Camera = $Camera
@onready var combat_ui : CombatUI = $CombatUI
@onready var default_ui : DefaultUI = $DefaultUI
@onready var top_left_spawn_limit : Marker2D = $TopLeftSpawnLimit
@onready var bottom_right_spawn_limit : Marker2D = $BottomRightSpawnLimit

var player : Player
var enemy_type_array : Array
var enemies : Array

func _ready():
	MusicPlayer.play_music(MusicPlayer.THE_BAY)
	
	enemy_type_array.append(TestEnemy)
	enemy_type_array.append(FastEnemy)
	enemy_type_array.append(Ranger)
	
	#instantiate player
	player = Player.instantiate() as Player
	player.position = player_spawn_marker.position
	map.add_child(player)
	
	#camera setup
	camera.set_target(player, true)
	
	#combat manager setup
	combat_manager.setup(player, combat_ui, camera, map)
	combat_manager.combat_ended.connect(_on_combat_manager_combat_ended)
	
	#combat ui setup
	combat_ui.setup(player, combat_manager)

func _unhandled_input(event):
	if event.is_action_pressed("tab"):
		if not combat_manager.in_combat:
			spawn_enemies()
			start_combat()

func spawn_enemies():
	var number_of_enemies = randi_range(3, 6)
	while enemies.size() < number_of_enemies:
		var type = enemy_type_array[randi_range(0, enemy_type_array.size() - 1)]
		var enemy = type.instantiate()
		enemy.init(player)
		
		var pos : Vector2
		var can_continue = false
		while can_continue == false:
			pos.x = randi_range(top_left_spawn_limit.position.x, bottom_right_spawn_limit.position.x)
			pos.y = randi_range(top_left_spawn_limit.position.y, bottom_right_spawn_limit.position.y)
			can_continue = true
			for e in enemies:
				if pos.distance_to(e.position) < 50:
					can_continue = false
					break
			
		enemy.position = pos
		enemies.append(enemy)
		map.add_child(enemy)

func start_combat():
	default_ui.hide()
	combat_ui.show()
	combat_manager.start_combat()

func end_combat():
	combat_ui.hide()
	default_ui.show()


func _on_enemy_player_spotted():
	start_combat()
	
func _on_combat_manager_combat_ended():
	end_combat()
