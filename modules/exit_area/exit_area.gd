class_name ExitArea
extends Area2D


@export var target_scene : PackedScene
@export var target_spawn : String


func _on_body_entered(body):
	SceneManager.change_scene(target_scene, target_spawn)
