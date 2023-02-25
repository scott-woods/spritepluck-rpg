extends CombatAction


@export var UtilitySelector : PackedScene

var selected_utility

func _ready():
	label = "Use Utility"
	type = "MISC"

func check_availability():
	#if no utilities are on map, disable
	if player.map_utilities.get_children().size() == 0:
		enabled = false
		return
	#otherwise, loop through utils. If any aren't queued, enable and return
	else:
		for util in player.map_utilities.get_children():
			#non-queued util found. Can use utility
			if !util.queued:
				enabled = true
				return
		#no non-queued utilities found. can't use utility
		enabled = false

func setup(simulation_player):
	in_setup = true
	var selector = UtilitySelector.instantiate()
	var current_camera_target = camera.target
	var current_pos = simulation_player.global_position
	selector.utility_focused.connect(func(utility):
		utility.focus()
		camera.set_target(utility)
		if utility.projected_player_position:
			simulation_player.global_position = utility.projected_player_position
		else:
			simulation_player.global_position = current_pos
	)
	
	#get only utils that haven't already been queued
	var utils = get_tree().get_nodes_in_group("utilities").duplicate()
	for util in utils:
		if util.queued:
			utils.erase(util)
	
	selector.init(utils, player, camera)
	add_child(selector)
	selected_utility = await selector.utility_selected
	selected_utility.queued = true
	selector.queue_free()
	camera.target = current_camera_target
	in_setup = false
	emit_signal("setup_finished", true)
	
func execute():
	selected_utility.call_deferred("trigger")
	await selected_utility.trigger_completed


