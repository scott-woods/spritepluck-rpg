class_name CombatAction
extends Node2D


signal setup_finished(can_continue)

var player : Player
var label
var type
var camera : Camera
var enabled
var in_setup = false

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
	print("%s missing overwrite of the setup method" % label)
	return false

func execute():
	print("%s missing overwrite of the execute method" % label)
	return false