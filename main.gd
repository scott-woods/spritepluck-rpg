extends Node


@export var default_room : PackedScene

@onready var viewport_container = $SubViewportContainer
@onready var viewport = $SubViewportContainer/SubViewport
@onready var world : Node2D = $SubViewportContainer/SubViewport/World

var current_room : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#new random seed
	randomize()
	
	ViewportManager.viewport_container = viewport_container
	ViewportManager.viewport = viewport
	
	#connect to signals
	SceneManager.scene_change_started.connect(_on_scene_manager_scene_change_started)
	SceneManager.faded_to_black.connect(_on_scene_manager_faded_to_black)
	
	#start default room
	current_room = default_room.instantiate()
	world.add_child(current_room)
	
func _on_scene_manager_scene_change_started(new_scene):
	pass

func _on_scene_manager_faded_to_black(new_scene):
	world.remove_child(current_room)
	current_room.queue_free()
	current_room = new_scene
	world.add_child(current_room)
	SceneManager.fade_to_normal()
