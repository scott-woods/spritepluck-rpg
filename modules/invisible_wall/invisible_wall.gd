class_name InvisibleWall
extends StaticBody2D


@onready var collision = $Collision
@onready var sprite : Sprite2D = $Sprite

func _ready():
	sprite.texture.size.x = collision.shape.size.x
	sprite.texture.size.y = collision.shape.size.y
	
func disable():
	collision.set_deferred("disabled", true)
	sprite.hide()
