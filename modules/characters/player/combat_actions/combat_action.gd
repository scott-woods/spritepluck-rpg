class_name CombatAction
extends Node2D


signal setup_finished(can_continue : bool)

var player : Player
var camera : Camera
var enabled : bool
var in_setup : bool = false

func init(init_player : Player, camera):
	player = init_player
	self.camera = camera

func _unhandled_input(event):
	if event.is_action_pressed("cancel"):
		if in_setup:
			in_setup = false
			emit_signal("setup_finished", false)

func check_availability():
	enabled = true

func setup(simulation_player):
	print("%s missing overwrite of the setup method")
	return false

func execute():
	print("%s missing overwrite of the execute method")
	return false
