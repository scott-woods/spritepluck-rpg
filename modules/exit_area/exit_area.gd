class_name ExitArea
extends Area2D


@export var target_scene : PackedScene
@export var target_spawn : String

@onready var collision = $Collision

func _on_body_entered(body):
	collision.set_deferred("disabled", true)
	SceneManager.change_scene(target_scene, target_spawn)
