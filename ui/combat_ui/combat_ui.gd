class_name CombatUI
extends Control


signal action_selected(action)
signal end_turn_selected

const ActionButton = preload("res://ui/combat_ui/action_button.tscn")

@onready var action_bar : ProgressBar = $ActionBar
@onready var black_overlay : ColorRect = $BlackOverlay
@onready var actions_container: VBoxContainer = $ActionsContainer
@onready var action_buttons = $ActionsContainer/HBoxContainer/ActionButtons
@onready var attacks_button = $ActionsContainer/HBoxContainer/ActionButtons/AttacksButton
@onready var misc_button = $ActionsContainer/HBoxContainer/ActionButtons/MiscButton
@onready var end_turn_button = $ActionsContainer/HBoxContainer/ActionButtons/EndTurnButton
@onready var attack_options = $ActionsContainer/HBoxContainer/AttackOptions
@onready var misc_options = $ActionsContainer/HBoxContainer/MiscOptions
@onready var player_health_label : Label = $VBoxContainer/PlayerHealthLabel
@onready var utility_label : Label = $VBoxContainer/UtilityLabel
@onready var actions_label : Label = $ActionsContainer/ActionsLabel
@onready var animation_player : AnimationPlayer = $ActionBar/AnimationPlayer

var player : Player
var last_selected_button

#init with necessary data
func init(player):
	self.player = player
	player.start_turn_button_pressed.connect(_on_player_start_turn_button_pressed)
	player.attack_timer_started.connect(_on_player_attack_timer_started)
	player.health_changed.connect(_on_player_health_changed)
	player.current_utility_changed.connect(_on_player_current_utility_changed)
	player.attack_timer_finished.connect(_on_player_attack_timer_finished)
	player_health_label.text = "HP: " + str(player.stats.hp)
	utility_label.text = "Utility: " + player.current_utility.label

func _process(delta):
	action_bar.value = player.action_timer.wait_time - player.action_timer.time_left

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if actions_container.visible:
			if attack_options.visible:
				show_action_menu(attacks_button)
			elif misc_options.visible:
				show_action_menu(misc_button)

#called once when combat starts
func enter_combat_state():
	action_bar.show()
	player_health_label.show()
	utility_label.show()
	#init buttons based on what player has available
	for action in player.actions.get_children():
		var button = ActionButton.instantiate()
		button.text = action.label
		button.action = action
		button.focus_entered.connect(func():
			SoundPlayer.play_sound(SoundPlayer.MENU_MOVE))
		button.connect("pressed", func(): _on_action_button_selected(action))
		match action.type:
			"ATTACK":
				attack_options.add_child(button)
			"MISC":
				misc_options.add_child(button)

#show action type buttons (called every time player starts selecting an action)
func show_action_menu(default_button = attacks_button):
	actions_container.show()
	action_buttons.show()
	for button in action_buttons.get_children():
		button.disabled = false
		button.focus_mode = Control.FOCUS_ALL
	if player.queued_actions.size() == 0:
		end_turn_button.disabled = true
		end_turn_button.focus_mode = Control.FOCUS_NONE
	default_button.grab_focus()
	attack_options.hide()
	disable_buttons(attack_options.get_children())
	misc_options.hide()
	disable_buttons(misc_options.get_children())

func disable_buttons(buttons):
	for button in buttons:
		button.disabled = true
		button.focus_mode = Control.FOCUS_NONE
				
func reset_actions_menu():
	for attack in attack_options.get_children():
		attack.queue_free()
	for misc in misc_options.get_children():
		misc.queue_free()

func show_overlay():
	black_overlay.show()
	
func hide_overlay():
	black_overlay.hide()

func reset():
	reset_actions_menu()
	utility_label.hide()
	animation_player.play("RESET")
	


#Show attack options
func _on_attacks_button_pressed():
	SoundPlayer.play_sound(SoundPlayer.MENU_SELECT)
	last_selected_button = attacks_button
	disable_buttons(action_buttons.get_children())
	attack_options.show()
	for button in attack_options.get_children():
		button.disabled = !button.action.enabled
		button.focus_mode = Control.FOCUS_ALL
	attack_options.get_children()[0].grab_focus()


#show misc options
func _on_misc_button_pressed():
	SoundPlayer.play_sound(SoundPlayer.MENU_SELECT)
	last_selected_button = misc_button
	disable_buttons(action_buttons.get_children())
	misc_options.show()
	for button in misc_options.get_children():
		button.disabled = !button.action.enabled
		button.focus_mode = Control.FOCUS_ALL
	misc_options.get_children()[0].grab_focus()


func _on_yes_button_pressed():
	SoundPlayer.play_sound(SoundPlayer.TYLER_YES)


#called when an action is selected
func _on_action_button_selected(action):
	SoundPlayer.play_sound(SoundPlayer.MENU_SELECT)
	last_selected_button = get_tree().root.gui_get_focus_owner()
	#only hide container for now, in case player wants to go back
	actions_container.hide()
	emit_signal("action_selected", action)
	

func _on_player_health_changed(new_value):
	player_health_label.text = "HP: " + str(new_value)


func _on_player_attack_timer_started(timer):
	action_bar.max_value = timer.time_left

func _on_player_attack_timer_finished():
	animation_player.play("ACTION_BAR_FLASH")
	
func _on_player_start_turn_button_pressed():
	animation_player.play("RESET")

func _on_attacks_button_focus_entered():
	SoundPlayer.play_sound(SoundPlayer.MENU_MOVE)


func _on_misc_button_focus_entered():
	SoundPlayer.play_sound(SoundPlayer.MENU_MOVE)


func _on_yes_button_focus_entered():
	SoundPlayer.play_sound(SoundPlayer.MENU_MOVE)


func _on_end_turn_button_focus_entered():
	SoundPlayer.play_sound(SoundPlayer.MENU_MOVE)


func _on_end_turn_button_pressed():
	SoundPlayer.play_sound(SoundPlayer.MENU_SELECT)
	actions_container.hide()
	emit_signal("end_turn_selected")
	

func _on_player_current_utility_changed(utility):
	utility_label.text = "Utility: " + utility.label
