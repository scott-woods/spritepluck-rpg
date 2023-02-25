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
var global_origin : Vector2

func init(initial_direction, simulation_player, radius : int):
	self.direction = initial_direction
	self.simulation_player = simulation_player
	global_origin = simulation_player.position
	self.radius = radius
	return self
	
func _ready():
	add_point(Vector2.ZERO)
	var end_point = direction * radius
	add_point(end_point)
	simulation_player.position = global_origin + end_point

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
		add_point(new_point)
		simulation_player.position = global_origin + new_point
