class_name Camera
extends Node2D


const SMOOTH_FACTOR = 4
const SNAP_DISTANCE = 2

@export var target : Node2D

var smoothing_enabled = true

func _ready():
	if target:
		var viewport = get_viewport()
		var canvas_transform = viewport.canvas_transform
		canvas_transform[2] = -target.global_position + Vector2(viewport.content_scale_size / 2)
		viewport.set_canvas_transform(canvas_transform)

func _process(delta):
	if target:
		var viewport = get_viewport()
		var canvas_transform = viewport.canvas_transform
		var target_pos = -target.global_position + Vector2(viewport.content_scale_size / 2)
		if canvas_transform[2].distance_to(target_pos) <= SNAP_DISTANCE:
			canvas_transform[2] = target_pos
			return
		if smoothing_enabled:
			canvas_transform[2] = canvas_transform[2].lerp(target_pos, SMOOTH_FACTOR * delta)
		else:
			canvas_transform[2] = target_pos
		viewport.set_canvas_transform(canvas_transform)

#set follow target, either instantly or smoothed
func set_target(target : Node2D, instant : bool = false):
	self.target = target
	if instant:
		var viewport = get_viewport()
		var canvas_transform = viewport.canvas_transform
		canvas_transform[2] = -target.global_position + Vector2(viewport.content_scale_size / 2)
		viewport.set_canvas_transform(canvas_transform)
