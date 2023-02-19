class_name UtilitySelector
extends Node


signal utility_selected(utility)
signal utility_focused(utility)

var utilities : Array
var selected_utility
var player : Player
var camera : Camera

func init(utils, player, camera):
	self.player = player
	self.camera = camera
	self.utilities = utils
	utilities.sort_custom(sort_utilities)
	selected_utility = utilities[0]
	camera.target = selected_utility
	emit_signal("utility_focused", selected_utility)

func _input(event):
	if event.is_action_pressed("ui_right"):
		var index = utilities.find(selected_utility)
		if index == utilities.size() - 1:
			selected_utility = utilities.front()
		else:
			selected_utility = utilities[index + 1]
		camera.target = selected_utility
		emit_signal("utility_focused", selected_utility)
	elif event.is_action_pressed("ui_left"):
		var index = utilities.find(selected_utility)
		if index == 0:
			selected_utility = utilities.back()
		else:
			selected_utility = utilities[index - 1]
		camera.target = selected_utility
		emit_signal("utility_focused", selected_utility)
	elif event.is_action_pressed("ui_accept"):
		emit_signal("utility_selected", selected_utility)

func sort_utilities(a, b) -> bool:
	var a_dist = player.global_position.distance_to(a.global_position)
	var b_dist = player.global_position.distance_to(b.global_position)
	if a_dist < b_dist:
		return true
	return false
