class_name CombatManager2
extends Node


signal simulation_player_created(simulation_player)
signal action_created(action)
signal action_queued
signal combat_ended
signal turn_phase_ended
signal action_setup_canceled

@export var SimulationPlayer : PackedScene
@export var UseUtility : PackedScene

var player : Player
var combat_ui : CombatUI2
var simulation_player : SimulationPlayer
var camera : Camera

func setup(player : Player, enemies : Array, combat_ui : CombatUI2, camera : Camera):
	#connect to player
	self.player = player
	player.start_turn_button_pressed.connect(_on_player_start_turn_button_pressed)
	player.finished_executing_actions.connect(_on_player_finished_executing_actions)
	
	#connect to ui signals
	self.combat_ui = combat_ui
	combat_ui.action_selected.connect(_on_combat_ui_action_selected)
	combat_ui.use_utility_selected.connect(_on_combat_ui_use_utility_selected)
	combat_ui.end_turn_button_pressed.connect(_on_combat_ui_end_turn_button_pressed)
#	combat_ui.attack_selected.connect(_on_combat_ui_attack_selected)
#	combat_ui.use_utility_selected.connect(_on_combat_ui_use_utility_selected)
#	combat_ui.item_selected.connect(_on_combat_ui_item_selected)
#	combat_ui.special_selected.connect(_on_combat_ui_special_selected)
#	combat_ui.end_turn_button_pressed.connect(_on_combat_ui_end_turn_button_pressed)
	
	self.camera = camera

func start_combat():
	player.enter_combat_state()
	get_tree().call_group("enemies", "enter_combat_state")
	start_dodge_phase()
	
func start_dodge_phase():
	player.start_dodge_phase()

func end_combat():
	player.exit_combat_state()
	MusicPlayer.stop_music()
	emit_signal("combat_ended")
	
func setup_action(action : CombatAction):
	action.init(player, camera)
	action.position = simulation_player.position
	emit_signal("action_created", action)
	var current_position = simulation_player.position
	action.setup(simulation_player)
	var success = await action.setup_finished
	await get_tree().process_frame
	if success:
		player.queue_action(action)
		if player.queued_actions.size() == player.stats.max_actions:
			end_turn_phase()
		else:
			camera.set_target(simulation_player)
			emit_signal("action_queued")
	else:
		camera.set_target(simulation_player)
		simulation_player.position = current_position
		action.queue_free()
		emit_signal("action_setup_canceled")

func end_turn_phase():
	simulation_player.queue_free()
	get_tree().paused = false
	MusicPlayer.disable_filter()
	camera.set_target(player)
	player.execute_actions()
	emit_signal("turn_phase_ended")


func _on_player_start_turn_button_pressed():
	get_tree().paused = true
	MusicPlayer.apply_filter()
	simulation_player = SimulationPlayer.instantiate()
	emit_signal("simulation_player_created", simulation_player)
	
func _on_player_finished_executing_actions():
	get_tree().call_group("utilities", "queue_free")
	if get_tree().get_nodes_in_group("enemies").size() < 1:
		end_combat()
	else:
		start_dodge_phase()

func _on_combat_ui_action_selected(selected_action : CombatActionResource):
	var action = selected_action.scene.instantiate() as CombatAction
	setup_action(action)
	
func _on_combat_ui_use_utility_selected():
	var action = UseUtility.instantiate() as CombatAction
	setup_action(action)

func _on_combat_ui_item_selected(item):
	pass
	
func _on_combat_ui_special_selected(special):
	pass
	
func _on_combat_ui_end_turn_button_pressed():
	end_turn_phase()
