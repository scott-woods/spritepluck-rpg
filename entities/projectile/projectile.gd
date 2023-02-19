class_name Projectile
extends Hitbox


@onready var sprite : Sprite2D = $Sprite
@onready var visible_notifier : VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

@export var speed : int

var velocity : Vector2
var direction : Vector2
var reflected := false

func fire(direction : Vector2):
	self.direction = direction
	var angle = rad_to_deg(direction.angle()) + 90
	rotate(deg_to_rad(angle))
	velocity = direction * speed

func reflect():
	reflected = true
	if get_collision_layer_value(4):
		set_collision_layer_value(4, false)
		set_collision_layer_value(5, true)
	elif get_collision_layer_value(5):
		set_collision_layer_value(5, false)
		set_collision_layer_value(4, true)
	direction *= -1
	rotate(deg_to_rad(180))
	velocity = direction * speed

func _process(delta):
	translate(velocity * delta)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	if reflected:
		reflected = false
	else:
		queue_free()
