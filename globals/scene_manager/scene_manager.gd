extends Node


signal scene_change_started(scene)
signal scene_change_finished
signal faded_to_black(scene)

@onready var transition_overlay = $TransitionLayer/TransitionOverlay
@onready var transition_animator = $TransitionAnimator

var current_spawn_point : String

func change_scene(new_scene : PackedScene, target_spawn : String):
	current_spawn_point = target_spawn
	transition_animator.play("FADE_TO_BLACK")
	var scene = new_scene.instantiate()
	emit_signal("scene_change_started", scene)
	await transition_animator.animation_finished
	emit_signal("faded_to_black", scene)

func fade_to_normal():
	transition_animator.play("FADE_TO_NORMAL")
	await transition_animator.animation_finished
	emit_signal("scene_change_finished")
