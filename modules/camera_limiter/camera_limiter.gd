class_name CameraLimiter
extends Node2D


@onready var top_left : Marker2D = $TopLeft
@onready var bottom_right : Marker2D = $BottomRight

func _ready():
	#get viewport size
	var viewport_size = get_tree().root.content_scale_size
	
	#get limit size
	var limit_size = Vector2(bottom_right.position.x - top_left.position.x,
	bottom_right.position.y - top_left.position.y)
	
	#adjust limits to at least the size of the viewport if necessary
	if limit_size.x < viewport_size.x:
		var diff = viewport_size.x - limit_size.x
		top_left.position.x -= diff / 2
		bottom_right.position.x += diff / 2
	if limit_size.y < viewport_size.y:
		var diff = viewport_size.y - limit_size.y
		top_left.position.y -= diff / 2
		bottom_right.position.y += diff / 2
		
	#set camera limits
	Game.camera.limit_top = top_left.position.y
	Game.camera.limit_left = top_left.position.x
	Game.camera.limit_bottom = bottom_right.position.y
	Game.camera.limit_right = bottom_right.position.x

func _exit_tree():
	Game.camera.limit_top = -10000000
	Game.camera.limit_left = -10000000
	Game.camera.limit_bottom = 10000000
	Game.camera.limit_right = 10000000
