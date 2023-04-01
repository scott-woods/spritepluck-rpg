class_name ExitArea
extends Area2D


@export var target_scene : PackedScene
@export var target_spawn : String
@export var use_room_manager : bool = false

@onready var collision = $Collision

func _on_body_entered(body):
	collision.set_deferred("disabled", true)
	if !use_room_manager:
		SceneManager.change_scene(target_scene, target_spawn)
	else:
		RoomsManager.get_next_room(target_spawn)
