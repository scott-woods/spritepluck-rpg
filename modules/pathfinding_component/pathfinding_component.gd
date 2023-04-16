class_name PathfindingComponent
extends Node2D


const STEERING_OPTIONS = [-.1, .1]
const DIRECTIONS : Array = [
	Vector2(0, -1), Vector2(1, -1), Vector2(1, 0), Vector2(1, 1),
	Vector2(0, 1), Vector2(-1, 1), Vector2(-1, 0), Vector2(-1, -1)
	]
const RAYCAST_DANGER_VALUE : int = 5
const RAYCAST_ADJ_DANGER_VALUE : int = 2

@export var velocity_component : VelocityComponent
@export var raycast_radius : int

@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D
@onready var raycasts : Array = $Raycasts.get_children()

var interest_vector : Array

func _ready():
	for i in 8:
		var dir = DIRECTIONS[i]
		var raycast = raycasts[i]
		#init raycasts
		raycast.target_position = dir * raycast_radius
		#init interest vector
		interest_vector.append(0)

func set_target_position(target : Vector2):
	navigation_agent.target_position = target

func follow_path() -> void:
	if navigation_agent.is_navigation_finished():
		return
	
	var next_path_pos = navigation_agent.get_next_path_position()
	
	var danger_array : Array = [0, 0, 0, 0, 0, 0, 0, 0]
	
	#get interest and danger array values
	for i in 8:
		var direction = DIRECTIONS[i]
		var raycast = raycasts[i]
		
		#set interest vector values
		var desired_direction = global_position.direction_to(next_path_pos)
		interest_vector[i] = desired_direction.dot(direction.normalized())
		
		#check raycasts
		if raycast.is_colliding():
			#set danger value
			danger_array[i] = RAYCAST_DANGER_VALUE
			
			#set adjacent danger values
			var next = i + 1
			next = clamp(next, 1, 7)
			danger_array[next] = clamp(danger_array[next], RAYCAST_ADJ_DANGER_VALUE, RAYCAST_DANGER_VALUE)
			var prev = i - 1
			prev = clamp(prev, 0, 6)
			danger_array[prev] = clamp(danger_array[prev], RAYCAST_ADJ_DANGER_VALUE, RAYCAST_DANGER_VALUE)
	
	#get context map values
	var context_map : Array
	for i in 8:
		context_map.append(interest_vector[i] - danger_array[i])
	
	var direction = DIRECTIONS[context_map.find(context_map.max())].normalized()
	
	var desired_velocity = direction * velocity_component.speed

	navigation_agent.set_velocity(desired_velocity)


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
#	if safe_velocity.x == 0:
#		safe_velocity.x += STEERING_OPTIONS.pick_random()
#	if safe_velocity.y == 0:
#		safe_velocity.y += STEERING_OPTIONS.pick_random()
	velocity_component.set_velocity(safe_velocity)
