class_name VelocityComponent
extends Node2D


@export var speed : float
@export var steering_factor : float

var velocity : Vector2

func accelerate_in_direction(direction : Vector2) -> void:
	velocity = direction * speed

func set_velocity(new_velocity : Vector2):
	if velocity == Vector2.ZERO:
		velocity = new_velocity
	else:
		var steering_force = new_velocity - velocity
		if steering_factor:
			steering_force = steering_force * steering_factor
		velocity = velocity + (steering_force * get_physics_process_delta_time())

func move(character : CharacterBody2D):
	character.velocity = velocity
	character.move_and_slide()
