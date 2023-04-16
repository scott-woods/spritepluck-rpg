class_name Hitbox
extends Area2D


@onready var collision : CollisionShape2D = $Collision

@export var damage : int

func enable():
	collision.disabled = false

func disable():
	collision.disabled = true

func reflect():
	pass
