extends Node


signal scene_change_started(scene)
signal scene_change_finished
signal faded_to_black(scene)

@onready var transition_overlay = $TransitionLayer/TransitionOverlay
@onready var transition_animator = $TransitionAnimator

var current_spawn_point : String
var transitioning : bool = false
var world : Node2D
var current_scene : Node

func change_scene(new_scene : PackedScene, target_spawn : String):
	transitioning = true
	var scene = new_scene.instantiate()
	current_spawn_point = target_spawn
	transition_animator.play("FADE_TO_BLACK")
	emit_signal("scene_change_started", scene)
	await transition_animator.animation_finished
	if (Game.player.get_parent()):
		Game.player.get_parent().remove_child(Game.player)
	current_scene.queue_free()
	current_scene = scene
	world.add_child(scene)
	fade_to_normal()

func fade_to_normal():
	transition_animator.play("FADE_TO_NORMAL")
	await transition_animator.animation_finished
	transitioning = false
	emit_signal("scene_change_finished")
