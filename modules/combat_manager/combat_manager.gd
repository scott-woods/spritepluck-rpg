class_name CombatManager
extends Node


signal action_created(action : CombatAction)
signal action_queued(player : Player)
signal combat_ended
signal turn_phase_started(player : Player)
signal simulation_player_created(simulation_player : SimulationPlayer)
signal turn_phase_ended
signal action_setup_canceled

@export var SimulationPlayer : PackedScene
@export var UseUtility : PackedScene
@export var default_combat_music : AudioStream
@export var enemy_types : Array[PackedScene]
@export var enemy_spawner : EnemySpawner

@onready var combat_ui : CombatUI = $CombatUI

var player : Player
var enemies : Array
var simulation_player : SimulationPlayer
var camera : Camera

func _ready():
	player = Game.player
	player.start_turn_button_pressed.connect(_on_player_start_turn_button_pressed)
	player.finished_executing_actions.connect(_on_player_finished_executing_actions)
	
	camera = Game.camera

#func setup(player : Player, combat_ui : CombatUI, camera : Camera, map : TileMap):
#	#connect to player
#	self.player = player
#	player.start_turn_button_pressed.connect(_on_player_start_turn_button_pressed)
#	player.finished_executing_actions.connect(_on_player_finished_executing_actions)
#	player.utility_dropped.connect(_on_player_utility_dropped)
#
#	#connect to ui signals
#	self.combat_ui = combat_ui
#	combat_ui.action_selected.connect(_on_combat_ui_action_selected)
#	combat_ui.use_utility_selected.connect(_on_combat_ui_use_utility_selected)
#	combat_ui.end_turn_button_pressed.connect(_on_combat_ui_end_turn_button_pressed)
#
#	self.camera = camera
#
#	self.map = map

#called once at the beginning of combat
func start_combat():
	combat_ui.setup_player_buttons()
	combat_ui.connect_to_combat_manager(self)
	combat_ui.show()
	player.enter_combat_state()
	enemies = enemy_spawner.spawn_enemies(enemy_types)
	for enemy in enemies:
		enemy = enemy as Enemy
		enemy.died.connect(_on_enemy_died)
		enemy.enter_combat_state()
	start_dodge_phase()

#called to start dodge phase
func start_dodge_phase():
	player.start_dodge_phase()

#called once to end combat
func end_combat():
	player.exit_combat_state()
	combat_ui.hide()
	emit_signal("combat_ended")

#setup a combat action after selection from ui
func setup_action(action : CombatAction):
	action.init(player, camera)
	action.position = simulation_player.position
	emit_signal("action_created", action)
	var current_position = simulation_player.position
	action.setup_finished.connect(func(success):
		await get_tree().process_frame
		if success:
			player.queue_action(action)
			if player.queued_actions.size() == player.max_actions_this_turn:
				end_turn_phase()
			else:
				camera.set_target(simulation_player)
				emit_signal("action_queued", player)
		else:
			camera.set_target(simulation_player)
			simulation_player.position = current_position
			action.queue_free()
			emit_signal("action_setup_canceled")
	)
	action.setup(simulation_player)

#called when playeris ready to start queuing actions
func start_turn_phase():
	get_tree().paused = true
	MusicPlayer.apply_filter()
	simulation_player = SimulationPlayer.instantiate()
	simulation_player.position = player.position
	emit_signal("simulation_player_created", simulation_player)
	emit_signal("turn_phase_started", player)

#called when player is done queuing actions
func end_turn_phase():
	simulation_player.queue_free()
	get_tree().paused = false
	MusicPlayer.disable_filter()
	camera.set_target(player)
	player.execute_actions()
	emit_signal("turn_phase_ended")


func _on_player_start_turn_button_pressed():
	start_turn_phase()
	
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

func _on_enemy_died():
	await get_tree().process_frame
	if get_tree().get_nodes_in_group("enemies").size() < 1:
		end_combat()
