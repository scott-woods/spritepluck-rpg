class_name RangerAction
extends Node2D


var ranger : Ranger

func _ready():
	await owner.ready
	ranger = owner as Ranger

func execute():
	print("Missing override of execute method, idiot")
