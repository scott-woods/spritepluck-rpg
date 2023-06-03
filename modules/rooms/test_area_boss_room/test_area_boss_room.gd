class_name TestAreaBossRoom
extends Node2D


@export var top_door : DungeonRoomDoor
@export var bottom_door : DungeonRoomDoor
@export var left_door : DungeonRoomDoor
@export var right_door : DungeonRoomDoor

@onready var player_spawner : PlayerSpawner = $PlayerSpawner

var room_data : DungeonRoomData = DungeonRoomData.new()

func init(data : DungeonRoomData):
	if data:
		room_data = data

# Called when the node enters the scene tree for the first time.
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
	Game.camera.set_target(Game.player)
