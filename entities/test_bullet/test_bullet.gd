class_name TestBullet
extends CharacterBody2D


var speed = 200
var angle

@onready var hitbox : Hitbox = $Hitbox

func _ready():
	velocity = Vector2.from_angle(angle) * speed
	
func _process(delta):
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_hitbox_area_entered(area):
	destroy()
	
func destroy():
	queue_free()
