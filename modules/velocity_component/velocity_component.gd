class_name VelocityComponent
extends Node2D


@export var speed : float

var velocity : Vector2

func accelerate_in_direction(direction : Vector2) -> void:
	velocity = direction * speed

func move(character : CharacterBody2D):
	character.velocity = velocity
	character.move_and_slide()
