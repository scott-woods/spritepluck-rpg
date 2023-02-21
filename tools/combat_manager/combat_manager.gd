class_name CombatManager
extends Node


signal player_queued

@export var SimulationPlayer : PackedScene

var player : Player
var enemies : Node
var utilities : Node
var combat_ui : CombatUI
var camera : Camera
var current_base : Node2D
var map
var simulation_players : Array
var in_combat = false

#provide necessary data
func init(player, enemies, utilities, combat_ui, camera, map):
	self.player = player
	player.start_turn_button_pressed.connect(_on_player_start_turn_button_pressed)
	self.enemies = enemies
	self.utilities = utilities
	self.combat_ui = combat_ui
	self.camera = camera
	self.map = map

#called once to start combat when player is spotted by an enemy
func _on_player_spotted():
	start_combat()

#start combat (called when spotted, or called directly in debug
func start_combat():
	for enemy in enemies.get_children():
		enemy.died.connect(_on_enemy_died)
		enemy.player_spotted.connect(_on_player_spotted)
	in_combat = true
	MusicPlayer.play_music(MusicPlayer.SPICY)
	player.enter_combat_state()
	get_tree().call_group("enemies", "enter_combat_state")
	combat_ui.show()
	combat_ui.enter_combat_state()

#called every time player is ready to start turn
func _on_player_start_turn_button_pressed():
	#pause processing and show overlay/other pause effects
	get_tree().paused = true
	combat_ui.show_overlay()
	
	#apply music filter
	MusicPlayer.apply_filter()
	
	#set player as initial base
	current_base = player
	
	#queue up player
	select_action()
	await player_queued
#	while player.queued_actions.size() < player.max_actions:
#		await get_tree().process_frame
#		await select_action()
		
	#unpause processing, hide overlay/other pause effects
	get_tree().paused = false
	combat_ui.hide_overlay()
	for sim_player in simulation_players:
		sim_player.queue_free()
	simulation_players.clear()
	
	#disable music filter
	MusicPlayer.disable_filter()
	
	#return camera to player
	camera.target = player
	
	#tell player to execute queued actions
	await player.execute_actions()
	
	#cleanup utilities from this turn
	for utility in utilities.get_children():
		utility.queue_free()
	
	#If any enemies are left, start timer again. Otherwise, 
	#tell player to exit combat state and hide ui
	if enemies.get_children().size() > 0:
		player.start_attack_timer()
	else:
		end_combat()

#queue up an action for player
func select_action():
	if player.queued_actions.size() < player.stats.max_actions:
		#check action availability (disable if they can't be used this turn)
		for action in player.actions.get_children():
			action.check_availability()
			
		#show action menu and wait until selection
		await get_tree().process_frame
		combat_ui.show_action_menu()
		combat_ui.connect("action_selected", _on_action_selected)
		combat_ui.connect("end_turn_selected", _on_end_turn_selected)
	else:
		emit_signal("player_queued")

func end_combat():
	in_combat = false
	MusicPlayer.stop_music()
	player.exit_combat_state()
	combat_ui.reset()
	combat_ui.reset_actions_menu()
	combat_ui.utility_label.hide()
	combat_ui.hide()


func _on_end_turn_selected():
	combat_ui.disconnect("end_turn_selected", _on_end_turn_selected)
	combat_ui.disconnect("action_selected", _on_action_selected)
	emit_signal("player_queued")

func _on_action_selected(action):
	#continue until an action is selected and setup
#	var x = false
#	while x == false:
	#wait until an action is selected
#	var action = await combat_ui.action_selected
		
	#duplicate and init selected action
	var action_copy = action.duplicate()
	player.actions.add_child(action_copy)
	action_copy.init(player, combat_ui, camera)
	
	#create simulated player for this action
	var simulation_player = SimulationPlayer.instantiate()
	simulation_player.global_position = current_base.global_position
	var previous_base = current_base
	current_base = simulation_player
	map.add_child(simulation_player)
	simulation_players.append(simulation_player)

	#tell action to setup
	action_copy.call_deferred("setup", simulation_player)
	var setup_finished = await action_copy.setup_finished
	
	#player pressed back button, return to attacks or misc
	if setup_finished == false:
		player.actions.remove_child(action_copy)
		action_copy.queue_free()
		current_base = previous_base
		camera.target = current_base
		map.remove_child(simulation_player)
		simulation_players.erase(simulation_player)
		simulation_player.queue_free()
		combat_ui.actions_container.show()
		combat_ui.last_selected_button.grab_focus()
	#successfully selected and setup action
	else:
		camera.target = simulation_player
		player.queued_actions.append(action_copy)
		combat_ui.disconnect("action_selected", _on_action_selected)
		combat_ui.disconnect("end_turn_selected", _on_end_turn_selected)
		select_action()


func _on_enemy_died():
	#if size is 1, this is the last enemy, just hasn't been freed yet
	if enemies.get_children().size() == 1:
		end_combat()
