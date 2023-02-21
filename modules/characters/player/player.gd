class_name Player
extends CharacterBody2D


signal attack_timer_started(timer)
signal attack_timer_finished
signal utility_dropped(utility)
signal health_changed(new_value)
signal start_turn_button_pressed
signal current_utility_changed(utility)

@onready var collision : CollisionShape2D = $Collision
@onready var sprite : Sprite2D = $Sprite
@onready var hurtbox : Area2D = $Hurtbox
@onready var state_machine : StateMachine = $StateMachine
@onready var actions = $Actions
@onready var action_timer = $ActionTimer
@onready var interact_ray : RayCast2D = $InteractRay

@export var stats : PlayerStats
@export var utilities : PlayerUtilities

const action_delay = .25
const time_between_actions = .5

var direction := Vector2(1, 0)
var last_direction := Vector2(1, 0)
var queued_actions : Array
var is_invincible := false
var current_utility : UtilityResource

var map_utilities #reference to utilities node in map
var combat_ui : CombatUI
var camera : Camera

#called when instantiated, before _ready
func init(utilities, combat_ui, camera):
	self.map_utilities = utilities
	self.combat_ui = combat_ui
	self.camera = camera

func _ready():
	current_utility = utilities.content[0]
	for action in actions.get_children():
		action.init(self, combat_ui, camera)
	action_timer.wait_time = stats.action_bar_time

#called at beginning of every dodge phase
func start_attack_timer():
	action_timer.start()
	emit_signal("attack_timer_started", action_timer)

#called once when combat starts
func enter_combat_state():
	start_attack_timer()
	state_machine.change_state("PlayerMove/PlayerCombat")
	
func exit_combat_state():
	action_timer.stop()
	state_machine.change_state("PlayerMove")

func drop_utility():
	if map_utilities.get_children().size() < stats.max_utility_drops:
		var util = current_utility.utility_scene.instantiate()
		util.init(self)
		util.global_position = global_position
		map_utilities.add_child(util)
		
func toggle_utility():
	var index = utilities.content.find(current_utility)
	if index == utilities.content.size() - 1:
		current_utility = utilities.content[0]
	else:
		current_utility = utilities.content[index + 1]
	emit_signal("current_utility_changed", current_utility)

func execute_actions():
	state_machine.change_state("PlayerExecutingActions")
	await get_tree().create_timer(action_delay).timeout
	for action in queued_actions:
		await action.execute()
		await get_tree().create_timer(time_between_actions).timeout
		action.queue_free()
	queued_actions.clear()
	state_machine.change_state("PlayerMove/PlayerCombat")
	
func take_damage(damage_amount):
	SoundPlayer.play_sound(SoundPlayer.PLAYER_HURT)
	stats.hp -= damage_amount
	if stats.hp < 0:
		stats.hp = 0
	emit_signal("health_changed", stats.hp)
	if stats.hp == 0:
		die()
	else:
		is_invincible = true
		hurtbox.set_deferred("monitoring", false)
		sprite.modulate = Color.RED
		await get_tree().create_timer(stats.invincible_time).timeout
		hurtbox.monitoring = true
		is_invincible = false
		sprite.modulate = Color.WHITE
		
func die():
	get_tree().quit()

func _on_hurtbox_area_entered(area):
	if state_machine.current_state.name == "PlayerReflecting":
		area.reflect()
	elif is_invincible == false:
		take_damage(area.damage)

#action timer finished, can now start turn
func _on_action_timer_timeout():
	emit_signal("attack_timer_finished")
	SoundPlayer.play_sound(SoundPlayer.ACTION_BAR_READY)
	while not Input.is_action_just_pressed("space"):
		await get_tree().process_frame
	emit_signal("start_turn_button_pressed")
