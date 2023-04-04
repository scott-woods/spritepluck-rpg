class_name CameraLimiter
extends Node


@onready var top_left : Marker2D = $TopLeft
@onready var bottom_right : Marker2D = $BottomRight

func _ready():
	Game.camera.limit_top = top_left.position.y
	Game.camera.limit_left = top_left.position.x
	Game.camera.limit_bottom = bottom_right.position.y
	Game.camera.limit_right = bottom_right.position.x
