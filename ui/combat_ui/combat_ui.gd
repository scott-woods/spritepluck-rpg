class_name CombatUI
extends CanvasLayer


signal action_selected(action)
signal use_utility_selected
signal end_turn_button_pressed

@export var CombatButton : PackedScene

@onready var action_bar : ActionBar = $Container/ActionBar
@onready var overlay : ColorRect = $Container/Overlay

@onready var player_hp_label = $Container/PlayerInfoContainer/PlayerHealthLabel
@onready var utility_label = $Container/PlayerInfoContainer/UtilityLabel

@onready var action_menu : VBoxContainer = $Container/ActionMenu
@onready var actions_container : VBoxContainer = $Container/ActionMenu/HBoxContainer/ActionsContainer
@onready var attack_button = $Container/ActionMenu/HBoxContainer/ActionsContainer/AttackButton
@onready var utility_button = $Container/ActionMenu/HBoxContainer/ActionsContainer/UtilityButton
@onready var item_button = $Container/ActionMenu/HBoxContainer/ActionsContainer/ItemButton
@onready var special_button = $Container/ActionMenu/HBoxContainer/ActionsContainer/SpecialButton
@onready var end_turn_button = $Container/ActionMenu/HBoxContainer/ActionsContainer/EndTurnButton
@onready var attacks_container : VBoxContainer = $Container/ActionMenu/HBoxContainer/AttacksContainer
@onready var specials_container : VBoxContainer = $Container/ActionMenu/HBoxContainer/SpecialsContainer

var button_press_sequence : Array

func _input(event):
	if event.is_action_pressed("cancel"):
		if action_menu.visible:
			if attacks_container.visible == true:
				attacks_container.hide()
				var button = button_press_sequence.pop_back()
				button.grab_focus()

func setup(player : Player, combat_manager : CombatManager):
	#connect to player signals
	player_hp_label.text = "HP: " + str(player.stats.hp)
	player.health_changed.connect(_on_player_health_changed)
	utility_label.text = "Utility: " + str(player.current_utility.utility_label)
	player.current_utility_changed.connect(_on_player_current_utility_changed)
	player.action_timer_started.connect(_on_player_action_timer_started)
	player.action_timer.timeout.connect(_on_player_action_timer_timeout)
	player.start_turn_button_pressed.connect(_on_player_start_turn_button_pressed)
	
	#setup attack buttons from player data
	if player.attacks:
		for attack in player.attacks:
			attack = attack as CombatActionResource
			var button = CombatButton.instantiate()
			button.text = attack.label
			button.pressed.connect(func(): _on_attack_selected(attack))
			attacks_container.add_child(button)
	
	#setup special buttons from player data
	if player.specials:
		for special in player.specials:
			special = special as CombatActionResource
			var button = CombatButton.instantiate()
			button.text = special.label
			button.pressed.connect(func(): _on_special_selected(special))
			specials_container.add_child(button)
			
	#connect to combat manager signals
	combat_manager.action_setup_canceled.connect(_on_combat_manager_action_setup_canceled)
	combat_manager.turn_phase_ended.connect(_on_combat_manager_turn_phase_ended)
	combat_manager.action_queued.connect(_on_combat_manager_action_queued)

func end_combat():
	action_bar.reset()


func _on_player_start_turn_button_pressed():
	overlay.show()
	action_menu.show()
	attacks_container.hide()
	specials_container.hide()
	attack_button.grab_focus()

func _on_player_health_changed(new_health):
	player_hp_label.text = "HP: " + str(new_health)

func _on_player_current_utility_changed(new_utility):
	utility_label.text = "Utility: " + new_utility.utility_label

func _on_player_action_timer_started(action_timer : Timer):
	action_bar.max_value = action_timer.wait_time
	while action_timer.time_left > 0:
		action_bar.value = action_timer.wait_time - action_timer.time_left
		await get_tree().process_frame

func _on_player_action_timer_timeout():
	action_bar.flash()

func _on_attack_button_pressed():
	SoundPlayer.play_sound(SoundPlayer.MENU_SELECT)
	button_press_sequence.append(attack_button)
	attacks_container.show()
	attacks_container.get_children()[0].grab_focus()

func _on_utility_button_pressed():
	SoundPlayer.play_sound(SoundPlayer.MENU_SELECT)
	button_press_sequence.append(utility_button)
	utility_button.release_focus()
	action_menu.hide()
	emit_signal("use_utility_selected")

func _on_item_button_pressed():
	pass # Replace with function body.

func _on_special_button_pressed():
	SoundPlayer.play_sound(SoundPlayer.MENU_SELECT)
	button_press_sequence.append(special_button)
	specials_container.show()
	specials_container.get_children()[0].grab_focus()

func _on_end_turn_button_pressed():
	SoundPlayer.play_sound(SoundPlayer.MENU_SELECT)
	end_turn_button.release_focus()
	action_menu.hide()
	emit_signal("end_turn_button_pressed")

func _on_attack_selected(attack):
	for button in attacks_container.get_children():
		if button.has_focus():
			button.release_focus()
			button_press_sequence.append(button)
	action_menu.hide()
	emit_signal("action_selected", attack)
	
func _on_special_selected(special):
	for button in specials_container.get_children():
		if button.has_focus():
			button.release_focus()
			button_press_sequence.append(button)
	action_menu.hide()
	emit_signal("action_selected", special)

func _on_combat_manager_action_setup_canceled():
	action_menu.show()
	var button = button_press_sequence.pop_back()
	button.grab_focus()

func _on_combat_manager_turn_phase_ended():
	button_press_sequence.clear()
	action_bar.reset()
	overlay.hide()
	
func _on_combat_manager_action_queued():
	action_menu.show()
	button_press_sequence.clear()
	attacks_container.hide()
	specials_container.hide()
	attack_button.grab_focus()
