class_name CombatManager
extends Node


signal action_queued
signal combat_ended
signal turn_phase_ended
signal action_setup_canceled

@export var SimulationPlayer : PackedScene
@export var UseUtility : PackedScene
@export var default_combat_music : AudioStream

var player : Player
var combat_ui : CombatUI
var simulation_player : SimulationPlayer
var camera : Camera
var map : TileMap

var in_combat = false

func setup(player : Player, combat_ui : CombatUI, camera : Camera, map : TileMap):
	#connect to player
	self.player = player
	player.start_turn_button_pressed.connect(_on_player_start_turn_button_pressed)
	player.finished_executing_actions.connect(_on_player_finished_executing_actions)
	player.utility_dropped.connect(_on_player_utility_dropped)
	
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
	
	self.map = map

func start_combat(combat_music : AudioStream = null):
	if combat_music == null:
		combat_music = default_combat_music
	MusicPlayer.play_music(combat_music)
	in_combat = true
	player.enter_combat_state()
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy = enemy as Enemy
		enemy.died.connect(_on_enemy_died)
		enemy.enter_combat_state()
	start_dodge_phase()
	
func start_dodge_phase():
	player.start_dodge_phase()

func end_combat():
	in_combat = false
	player.exit_combat_state()
	combat_ui.end_combat()
	MusicPlayer.stop_music()
	emit_signal("combat_ended")
	
func setup_action(action : CombatAction):
	action.init(player, camera)
	action.position = simulation_player.position
	map.add_child(action)
	var current_position = simulation_player.position
	action.setup_finished.connect(func(success):
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
	)
	action.setup(simulation_player)
	

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
	simulation_player.position = player.position
	map.add_child(simulation_player)
	
func _on_player_finished_executing_actions():
	get_tree().call_group("utilities", "queue_free")
	if get_tree().get_nodes_in_group("enemies").size() < 1:
		end_combat()
	else:
		start_dodge_phase()
		
func _on_player_utility_dropped(utility):
	map.add_child(utility)

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

func _on_enemy_died():
	await get_tree().process_frame
	if get_tree().get_nodes_in_group("enemies").size() < 1:
		end_combat()
