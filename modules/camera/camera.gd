class_name Camera
extends Camera2D


const SMOOTH_FACTOR = 16
const SNAP_DISTANCE = 2

@export var target : Node2D
@export var smoothing_enabled = true

@onready var actual_cam_pos := global_position

func _ready():
	if target:
#		actual_cam_pos = target.global_position
#		#actual_cam_pos = lerp(actual_cam_pos, target.global_position, delta*5)
#		var subpixel_pos = actual_cam_pos.round() - actual_cam_pos
#		ViewportManager.viewport_container.material.set_shader_parameter("cam_offset", subpixel_pos)
#		global_position = actual_cam_pos.round()
#		var viewport = get_viewport()
#		var canvas_transform = viewport.canvas_transform
#		canvas_transform[2] = -target.global_position + Vector2(viewport.content_scale_size / 2)
#		viewport.set_canvas_transform(canvas_transform)
		pass

func _physics_process(delta):
	if target:
		global_position = target.global_position
#	if target:
#		actual_cam_pos = target.global_position
##		var cam_pos = lerp(actual_cam_pos, target.global_position, 1)
##		actual_cam_pos = lerp(actual_cam_pos, cam_pos, delta*5)
#		var subpixel_pos = actual_cam_pos.round() - actual_cam_pos
#		ViewportManager.viewport_container.material.set_shader_parameter("cam_offset", subpixel_pos)
#		global_position = actual_cam_pos.round()
		
#		actual_cam_pos = target.global_position
#		#actual_cam_pos = lerp(actual_cam_pos, target.global_position, delta*5)
#		var subpixel_pos = actual_cam_pos.round() - actual_cam_pos
#		print(subpixel_pos)
#		ViewportManager.viewport_container.material.set_shader_parameter("cam_offset", subpixel_pos)
#		global_position = actual_cam_pos.round()
		
#		var target_pos = target.global_position
#		var cam_pos = lerp(actual_cam_pos, target_pos, 0.7)
#		actual_cam_pos = lerp(actual_cam_pos, cam_pos, delta*5)
#		var subpixel_pos = actual_cam_pos.round() - actual_cam_pos
#		ViewportManager.viewport_container.material.set_shader_parameter("cam_offset", subpixel_pos)
#		global_position = actual_cam_pos.round()
	
#	if target:
		#global_position = target.global_position
#		var viewport = get_viewport()
#		var canvas_transform = viewport.canvas_transform
#		canvas_transform[2] = target.global_position
#		viewport.set_canvas_transform(canvas_transform)
#		var target_pos = -target.global_position + Vector2(viewport.content_scale_size / 2)
##		if canvas_transform[2].distance_to(target_pos) <= SNAP_DISTANCE:
##			canvas_transform[2] = target_pos
##			return
#		if smoothing_enabled:
#			canvas_transform[2] = canvas_transform[2].lerp(target_pos, SMOOTH_FACTOR * delta)
#		else:
#			canvas_transform[2] = target_pos
#		viewport.set_canvas_transform(canvas_transform)

#set follow target, either instantly or smoothed
func set_target(target : Node2D, instant : bool = false):
	self.target = target
	if instant:
		global_position = target.global_position
	
#	self.target = target
#	if instant:
#		var viewport = get_viewport()
#		var canvas_transform = viewport.canvas_transform
#		canvas_transform[2] = -target.global_position + Vector2(viewport.content_scale_size / 2)
#		viewport.set_canvas_transform(canvas_transform)
