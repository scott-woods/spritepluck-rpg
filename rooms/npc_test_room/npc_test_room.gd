class_name NPCTestRoom
extends Node2D


const Player = preload("res://entities/player/player.tscn")

@onready var default_ui : DefaultUI = $UI/DefaultUI
@onready var map : TileMap = $Map
@onready var npcs : Node = $Map/NPCs

var player : Player

func _ready():
	player = Player.instantiate()
	map.add_child(player)
	
	get_tree().call_group("npcs", "init", default_ui)
