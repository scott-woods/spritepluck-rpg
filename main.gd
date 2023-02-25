extends Node


@export var default_room : PackedScene

@onready var world : Node2D = $World

var room : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	room = default_room.instantiate()
	world.add_child(room)
