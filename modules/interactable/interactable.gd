class_name Interactable
extends Area2D


signal interaction_started
signal interaction_finished

func interact():
	emit_signal("interaction_started")

func finish_interaction():
	emit_signal("interaction_finished")
