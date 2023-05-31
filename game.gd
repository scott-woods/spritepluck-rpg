extends Node


const Game : PackedScene = preload("res://game.tscn")
const Player : PackedScene = preload("res://modules/characters/player/player.tscn")
const Camera : PackedScene = preload("res://modules/camera/camera.tscn")

var viewport_container : SubViewportContainer
var viewport : SubViewport
var world : Node2D

var game : Node = Game.instantiate()
var player : Player = Player.instantiate()
var camera : Camera = Camera.instantiate()
var current_scene : Node

func _ready():
	#set process mode to always
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	#get random seed
	randomize()
	
	#get properties from Game node
	viewport_container = game.get_node("SubViewportContainer")
	viewport = game.get_node("SubViewportContainer/SubViewport")
	world = game.get_node("SubViewportContainer/SubViewport/World")
	
	var root : Window = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	
	#add camera to viewport
	viewport.add_child(camera)
	
	#setup Scene Manager values
	SceneManager.world = world
	SceneManager.current_scene = current_scene
	
	#set viewport manager values
	ViewportManager.viewport_container = viewport_container
	ViewportManager.viewport = viewport
	
	call_deferred("_deferred_ready", root)

func _deferred_ready(root : Window):
	#remove default scene from root
	root.remove_child(current_scene)
	
	#add game scene to root
	root.add_child(game)
	#add default scene to world
	world.add_child(current_scene)

func _input(event):
	if event.is_action_pressed("esc"):
		get_tree().quit()
