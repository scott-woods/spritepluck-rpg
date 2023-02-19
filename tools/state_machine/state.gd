class_name State
extends Node


var state_machine = null

func init(st_machine : StateMachine):
	state_machine = st_machine

func begin(params := {}) -> void:
	pass
	
func handle_input(event: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass

func end() -> void:
	pass
