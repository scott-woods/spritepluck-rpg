class_name ExitArea
extends Area2D


signal exited(target_spawn : String)

@export var target_scene : PackedScene
@export var target_spawn : String

@onready var collision = $Collision

func _on_body_entered(body):
	collision.set_deferred("disabled", true)
	var scene = target_scene.instantiate()
	SceneManager.change_scene(scene, target_spawn)
	emit_signal("exited", target_spawn)
