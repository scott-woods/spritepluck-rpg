class_name NPCTestRoom
extends Node2D


@export var Player : PackedScene

@onready var default_ui : DefaultUI = $DefaultUI

var player : Player

func _ready():
	player = Player.instantiate()
	add_child(player)
	
	var interactables = get_tree().get_nodes_in_group("interactables")
	default_ui.setup(interactables)
