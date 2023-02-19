extends Node


@export var FirstRoom : PackedScene

var world : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	world = FirstRoom.instantiate()
	add_child(world)
