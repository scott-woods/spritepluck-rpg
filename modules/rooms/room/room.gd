class_name Room
extends Node2D


@export var Player : PackedScene

@onready var map : TileMap = $Map
@onready var camera : Camera = $Camera
@onready var spawn_point_container : Node = $Map/SpawnPointContainer

var player : Player

func _ready():
	start()
	
func start():
	pass

func spawn_player(spawn_pos : Vector2):
	player = Player.instantiate() as Player
	player.position = spawn_pos
	map.add_child(player)
