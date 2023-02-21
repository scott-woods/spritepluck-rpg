class_name LineSelector
extends Line2D


signal line_selected(points)

@export var SimulationPlayer : PackedScene

var radius : int
var direction : Vector2
var end_point : Vector2
var speed = 200
var simulation_player
var center

func init(initial_direction, center, simulation_player, radius : int):
	self.direction = initial_direction
	self.center = center
	self.simulation_player = simulation_player
	self.radius = radius
	return self
	
func _ready():
	add_point(center)
	var end_point = direction * radius
	add_point(center + end_point)
	simulation_player.global_position = center + end_point

func _input(event):
	if event.is_action_pressed("accept"):
		emit_signal("line_selected", points)

func _process(delta):
	var direction_input = Input.get_axis("ui_left", "ui_right")
	if direction_input != 0:
		var angle = direction.angle()
		angle += deg_to_rad(speed * delta) * direction_input
		var new_point = Vector2(radius * cos(angle), radius * sin(angle))
		direction = new_point.normalized()
		remove_point(1)
		add_point(center + new_point)
		simulation_player.global_position = center + new_point
