extends Node


@export var FirstRoom : PackedScene

@onready var world : Node2D = $World

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	world.queue_free()
	var room = FirstRoom.instantiate()
	room.name = "World"
	world = room
	add_child(world)
