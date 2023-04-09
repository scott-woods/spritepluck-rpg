class_name PathfindingComponent
extends Node2D


@export var velocity_component : VelocityComponent

@onready var navigation_agent = $NavigationAgent2D

func set_target_position(target : Vector2):
	navigation_agent.target_position = target

func follow_path() -> void:
	if navigation_agent.is_navigation_finished():
		return
	
	var next_path_pos = navigation_agent.get_next_path_position()
	
	var direction = global_position.direction_to(next_path_pos)
	velocity_component.accelerate_in_direction(direction)

	navigation_agent.set_velocity(velocity_component.velocity)


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity_component.velocity = safe_velocity
