extends Node


@export var default_room : PackedScene
@export var Player : PackedScene

@onready var viewport_container = $SubViewportContainer
@onready var viewport = $SubViewportContainer/SubViewport
@onready var world : Node2D = $SubViewportContainer/SubViewport/World
@onready var camera : Camera = $SubViewportContainer/SubViewport/Camera

var current_room : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#new random seed
	randomize()
	
	ViewportManager.viewport_container = viewport_container
	ViewportManager.viewport = viewport
	
	#create player
	Game.player = Player.instantiate()
	add_child(Game.player)
	
	#setup camera
	Game.camera = camera
	
	#start default room
	SceneManager.world = world
	current_room = default_room.instantiate()
	world.add_child(current_room)
