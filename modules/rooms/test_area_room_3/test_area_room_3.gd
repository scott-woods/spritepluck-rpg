class_name TestAreaRoom3
extends Node2D


@export var top_door : DungeonRoomDoor
@export var bottom_door : DungeonRoomDoor
@export var left_door : DungeonRoomDoor
@export var right_door : DungeonRoomDoor

@onready var enemy_spawner : EnemySpawner = $EnemySpawner
@onready var combat_manager : CombatManager = $CombatManager
@onready var player_spawner : PlayerSpawner = $PlayerSpawner
@onready var map : TileMap = $Map

var room_data : DungeonRoomData = DungeonRoomData.new()

func init(data : DungeonRoomData):
	if data:
		room_data = data

func _ready():
	if top_door:
		top_door.move_to_coordinates = room_data.top_door_coordinates
	if bottom_door:
		bottom_door.move_to_coordinates = room_data.bottom_door_coordinates
	if left_door:
		left_door.move_to_coordinates = room_data.left_door_coordinates
	if right_door:
		right_door.move_to_coordinates = room_data.right_door_coordinates
	
	player_spawner.spawn_player()
	
	Game.player.utility_dropped.connect(_on_player_utility_dropped)
	
	combat_manager.combat_ended.connect(_on_combat_manager_combat_ended)
	
	Game.camera.set_target(Game.player)
	
	start()

func start():
	if SceneManager.transitioning:
		await SceneManager.scene_change_finished

	if room_data.room_cleared == false:
		combat_manager.start_combat()
	else:
		remove_walls()
 
func remove_walls():
	#open path to next rooms
	var removable_walls = get_tree().get_nodes_in_group("removable_walls")
	for wall in removable_walls:
		wall.collision.set_deferred("disabled", true)


func _on_player_utility_dropped(utility : Utility):
	map.add_child(utility)

func _on_combat_manager_combat_ended():
	room_data.room_cleared = true
	remove_walls()
