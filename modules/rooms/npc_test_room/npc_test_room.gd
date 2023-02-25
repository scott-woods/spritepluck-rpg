class_name NPCTestRoom
extends Node2D


@export var Player : PackedScene

@onready var default_ui : DefaultUI = $DefaultUI
@onready var map : TileMap = $Map
@onready var npcs : Node = $Map/NPCs

var player : Player

func _ready():
	player = Player.instantiate()
	map.add_child(player)
	
	get_tree().call_group("npcs", "init", default_ui)
