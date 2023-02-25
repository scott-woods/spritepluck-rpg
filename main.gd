extends Node


@export var default_room : PackedScene
@export var CombatUI : PackedScene

@onready var world : Node2D = $World
@onready var ui_canvas : CanvasLayer = $UICanvas
@onready var ui : Control = $UICanvas/DefaultUI

var room : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	room = default_room.instantiate()
	room.combat_started.connect(_on_combat_started)
	room.combat_ended.connect(_on_combat_ended)
	world.add_child(room)
	

func _on_combat_started():
	ui_canvas.hide()
	
func _on_combat_ended():
	ui_canvas.show()
