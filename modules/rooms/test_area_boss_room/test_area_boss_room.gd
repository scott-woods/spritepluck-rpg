class_name TestAreaBossRoom
extends Node2D


@export var top_door : DungeonRoomDoor
@export var bottom_door : DungeonRoomDoor
@export var left_door : DungeonRoomDoor
@export var right_door : DungeonRoomDoor

@onready var player_spawner : PlayerSpawner = $PlayerSpawner

# Called when the node enters the scene tree for the first time.
func _ready():
	player_spawner.spawn_player()
	Game.camera.set_target(Game.player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
