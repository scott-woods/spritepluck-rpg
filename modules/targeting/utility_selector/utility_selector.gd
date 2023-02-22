class_name UtilitySelector
extends Node


signal utility_selected(utility : Utility)
signal utility_focused(utility : Utility)

var utilities : Array
var selected_utility : Utility
var player : Player
var camera : Camera

func init(utils : Array, player : Player, camera : Camera):
	self.player = player
	self.camera = camera
	self.utilities = utils
	utilities.sort_custom(sort_utilities)
	selected_utility = utilities[0]
	emit_signal("utility_focused", selected_utility)

func _input(event):
	if event.is_action_pressed("ui_right"):
		selected_utility.unfocus()
		var index = utilities.find(selected_utility)
		if index == utilities.size() - 1:
			selected_utility = utilities.front()
		else:
			selected_utility = utilities[index + 1]
		emit_signal("utility_focused", selected_utility)
	elif event.is_action_pressed("ui_left"):
		selected_utility.unfocus()
		var index = utilities.find(selected_utility)
		if index == 0:
			selected_utility = utilities.back()
		else:
			selected_utility = utilities[index - 1]
		emit_signal("utility_focused", selected_utility)
	elif event.is_action_pressed("ui_accept"):
		selected_utility.unfocus()
		emit_signal("utility_selected", selected_utility)

func sort_utilities(a, b) -> bool:
	var a_dist = player.global_position.distance_to(a.global_position)
	var b_dist = player.global_position.distance_to(b.global_position)
	if a_dist < b_dist:
		return true
	return false
