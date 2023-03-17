class_name Interactable
extends Area2D


signal interaction_started
signal interaction_finished

@export var dialogue : Array[Resource]

func interact():
	emit_signal("interaction_started")
