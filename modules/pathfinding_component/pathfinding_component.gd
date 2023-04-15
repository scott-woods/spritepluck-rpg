class_name PathfindingComponent
extends Node2D


const STEERING_OPTIONS = [-.1, .1]

@export var velocity_component : VelocityComponent

@onready var navigation_agent = $NavigationAgent2D

func set_target_position(target : Vector2):
	navigation_agent.target_position = target

func follow_path() -> void:
	if navigation_agent.is_navigation_finished():
		return
	
	var next_path_pos = navigation_agent.get_next_path_position()
	
	var direction = global_position.direction_to(next_path_pos)
	var desired_velocity = direction * velocity_component.speed

	navigation_agent.set_velocity(desired_velocity)


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	if safe_velocity.x == 0:
		safe_velocity.x += STEERING_OPTIONS.pick_random()
	if safe_velocity.y == 0:
		safe_velocity.y += STEERING_OPTIONS.pick_random()
	velocity_component.velocity = safe_velocity
