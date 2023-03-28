class_name Player
extends CharacterBody2D


signal action_timer_started(action_timer)
signal utility_dropped(utility)
signal health_changed(new_value)
signal start_turn_button_pressed
signal current_utility_changed(utility)
signal finished_executing_actions
signal actions_increased(number_of_actions)

const ACTION_DELAY = .25
const TIME_BETWEEN_ACTIONS = .25
const MIN_ACTION_TIME : float = 1
const MAX_ACTION_TIME : float = 12
const FRICTION : float = .36

@onready var collision : CollisionShape2D = $Collision
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox : Area2D = $Hurtbox
@onready var state_machine : StateMachine = $StateMachine
@onready var action_timer = $ActionTimer
@onready var interact_ray : RayCast2D = $InteractRay

@export var stats : PlayerStats
@export var utilities : Array[Resource]
@export var attacks : Array[Resource]
@export var specials : Array[Resource]

var direction := Vector2(1, 0)
var last_direction := Vector2(1, 0)
var queued_actions : Array
var is_invincible := false
var current_utility : UtilityResource
var dropped_utilities : Array
var max_actions_this_turn = 0

func _ready():
	if utilities.size() > 0:
		current_utility = utilities[0]
	action_timer.wait_time = MAX_ACTION_TIME
	
	#connect to scene manager
	SceneManager.scene_change_started.connect(_on_scene_manager_scene_change_started)

#called once when combat starts
func enter_combat_state():
	state_machine.change_state("PlayerMove/PlayerCombat")

#called at start of dodge phase
func start_dodge_phase():
	#reset max actions this turn
	max_actions_this_turn = 0
	
	#start timer
	action_timer.start()
	emit_signal("action_timer_started", action_timer)
	
	#wait min time for first action to be available
	await get_tree().create_timer(MIN_ACTION_TIME).timeout
	max_actions_this_turn += 1
	emit_signal("actions_increased", max_actions_this_turn)
	SoundPlayer.play_sound(SoundPlayer.DASH_ATTACK)
	
	#keep adding max actions until max is reached or start turn is pressed
	var remaining_time : float = MAX_ACTION_TIME - MIN_ACTION_TIME
	var remaining_actions = stats.max_actions - 1
	var time : float = remaining_time / remaining_actions
	var timer : Timer = Timer.new()
	add_child(timer)
	timer.wait_time = time
	timer.one_shot = true
	timer.timeout.connect(func():
		max_actions_this_turn += 1
		emit_signal("actions_increased", max_actions_this_turn)
		SoundPlayer.play_sound(SoundPlayer.DASH_ATTACK)
		if max_actions_this_turn < stats.max_actions and not action_timer.is_stopped():
			timer.start()
	)
	timer.start()

	while not Input.is_action_just_pressed("space"):
		await get_tree().process_frame
	
	timer.stop()
	timer.queue_free()
	action_timer.stop()
	emit_signal("start_turn_button_pressed")
	
func exit_combat_state():
	for utility in dropped_utilities:
		utility.queue_free()
		dropped_utilities.erase(utility)
	action_timer.stop()
	state_machine.change_state("PlayerMove")

func drop_utility():
	if dropped_utilities.size() < stats.max_utility_drops:
		var utility = current_utility.utility_scene.instantiate()
		utility.init(self)
		utility.position = position
		dropped_utilities.append(utility)
		emit_signal("utility_dropped", utility)
		
func toggle_utility():
	var index = utilities.find(current_utility)
	if index == utilities.size() - 1:
		current_utility = utilities[0]
	else:
		current_utility = utilities[index + 1]
	emit_signal("current_utility_changed", current_utility)

func queue_action(action : CombatAction):
	queued_actions.append(action)

func execute_actions():
	state_machine.change_state("PlayerExecutingActions")
	await get_tree().create_timer(ACTION_DELAY).timeout
	for action in queued_actions:
		if state_machine.current_state.name != "PlayerExecutingActions":
			break
		await action.execute()
		await get_tree().create_timer(TIME_BETWEEN_ACTIONS).timeout
		action.queue_free()
	queued_actions.clear()
	dropped_utilities.clear()
	state_machine.change_state("PlayerMove/PlayerCombat")
	emit_signal("finished_executing_actions")
	
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

#action timer finished
func _on_action_timer_timeout():
	SoundPlayer.play_sound(SoundPlayer.ACTION_BAR_READY)

func _on_scene_manager_scene_change_started(scene):
	state_machine.change_state("PlayerIdle")
