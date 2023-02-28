class_name LineSelector
extends Line2D


signal line_selected(points)

@export var SimulationPlayer : PackedScene

@onready var raycast : RayCast2D = $RayCast2D

var radius : int
var direction : Vector2
var end_point : Vector2
var speed = 200
var simulation_player
var center
var global_origin : Vector2
var direction_input : float

func init(initial_direction, simulation_player, radius : int):
	self.direction = initial_direction
	self.simulation_player = simulation_player
	global_origin = simulation_player.position
	self.radius = radius
	return self
	
func _ready():
	add_point(Vector2.ZERO)
	add_point(Vector2.ZERO)
	var end_point = direction * radius
	raycast.target_position = end_point

func _input(event):
	if event.is_action_pressed("accept"):
		emit_signal("line_selected", points)

func _physics_process(delta):
	if raycast.is_colliding():
		raycast.target_position = get_adjusted_point()
	if points[1] != raycast.target_position:
		remove_point(1)
		add_point(raycast.target_position)
		simulation_player.position = global_origin + raycast.target_position
	direction_input = Input.get_axis("ui_left", "ui_right")
	if direction_input != 0:
		var angle = direction.angle()
		angle += deg_to_rad(speed * delta) * direction_input
		var new_point = Vector2(radius * cos(angle), radius * sin(angle))
		direction = new_point.normalized()
		raycast.target_position = new_point

func get_adjusted_point():
	var adjusted_point
	var point = raycast.get_collision_point()
	var distance = global_position.distance_to(point)
	adjusted_point = direction * distance
	adjusted_point -= direction * 8
	return adjusted_point
