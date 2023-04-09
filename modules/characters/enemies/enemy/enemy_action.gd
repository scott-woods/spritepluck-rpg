class_name EnemyAction
extends Node2D


var enemy : Enemy

func _ready():
	await owner.ready
	enemy = owner as Enemy

func execute():
	print("Missing override of execute method, idiot")
