class_name Hurtbox
extends Area2D


signal hit(hitbox : Hitbox)

@onready var collision : CollisionShape2D = $Collision

func enable():
	collision.disabled = false

func disable():
	collision.disabled = true


func _on_area_entered(area):
	emit_signal("hit", area)
