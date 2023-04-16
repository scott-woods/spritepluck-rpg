class_name UtilityEffectsComponent
extends Area2D


@export var character : CharacterBody2D

@onready var collision : CollisionShape2D = $Collision

func trigger_gravity_bomb_effect(gravity_bomb : GravityBomb, delta : float):
	var direction = character.global_position.direction_to(gravity_bomb.global_position)
	if character.global_position.distance_to(gravity_bomb.global_position) > 0:
		character.global_position += direction * gravity_bomb.PULL_SPEED * delta
