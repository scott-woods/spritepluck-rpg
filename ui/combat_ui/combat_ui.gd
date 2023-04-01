class_name CombatUI
extends CanvasLayer


signal action_selected(action)
signal use_utility_selected
signal end_turn_button_pressed

@export var CombatButton : PackedScene
@export var ActionReadyIcon : PackedScene

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
@onready var action_ready_icon_container : HBoxContainer = $Container/ActionReadyIconContainer

var button_press_sequence : Array
var action_ready_icons : Array
var player : Player

func _ready():
	player = Game.player
	player_hp_label.text = "HP: " + str(player.stats.hp)
	player.health_changed.connect(_on_player_health_changed)
	utility_label.text = "Utility: " + str(player.current_utility.utility_label)
	player.current_utility_changed.connect(_on_player_current_utility_changed)
	player.action_timer_started.connect(_on_player_action_timer_started)
	player.action_timer.timeout.connect(_on_player_action_timer_timeout)
	player.actions_increased.connect(_on_player_actions_increased)

func _input(event):
	if event.is_action_pressed("cancel"):
		if action_menu.visible:
			if attacks_container.visible == true:
				attacks_container.hide()
				for action_button in actions_container.get_children():
					action_button.set_focus_mode(Control.FOCUS_ALL)
				var button = button_press_sequence.pop_back()
				button.grab_focus()
			if specials_container.visible == true:
				specials_container.hide()
				for action_button in actions_container.get_children():
					action_button.set_focus_mode(Control.FOCUS_ALL)
				var button = button_press_sequence.pop_back()
				button.grab_focus()

func setup_player_buttons():
	#create action ready icons
	while action_ready_icons.size() < player.stats.max_actions:
		var icon = ActionReadyIcon.instantiate()
		action_ready_icons.append(icon)
		action_ready_icon_container.add_child(icon)
	
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

func connect_to_combat_manager(combat_manager : CombatManager):
	combat_manager.turn_phase_started.connect(_on_combat_manager_turn_phase_started)
	combat_manager.action_setup_canceled.connect(_on_combat_manager_action_setup_canceled)
	combat_manager.turn_phase_ended.connect(_on_combat_manager_turn_phase_ended)
	combat_manager.action_queued.connect(_on_combat_manager_action_queued)
	combat_manager.combat_ended.connect(_on_combat_manager_combat_ended)

func setup(player : Player, combat_manager : CombatManager):
	#connect to player signals
	player_hp_label.text = "HP: " + str(player.stats.hp)
	player.health_changed.connect(_on_player_health_changed)
	utility_label.text = "Utility: " + str(player.current_utility.utility_label)
	player.current_utility_changed.connect(_on_player_current_utility_changed)
	player.action_timer_started.connect(_on_player_action_timer_started)
	player.action_timer.timeout.connect(_on_player_action_timer_timeout)
	player.actions_increased.connect(_on_player_actions_increased)
	
	#create action ready icons
	while action_ready_icons.size() < player.stats.max_actions:
		var icon = ActionReadyIcon.instantiate()
		action_ready_icons.append(icon)
		action_ready_icon_container.add_child(icon)
	
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
	combat_manager.turn_phase_started.connect(_on_combat_manager_turn_phase_started)
	combat_manager.action_setup_canceled.connect(_on_combat_manager_action_setup_canceled)
	combat_manager.turn_phase_ended.connect(_on_combat_manager_turn_phase_ended)
	combat_manager.action_queued.connect(_on_combat_manager_action_queued)
	combat_manager.combat_ended.connect(_on_combat_manager_combat_ended)

func update_buttons(player : Player):
	var buttons_to_enable : Array
	var buttons_to_disable : Array
	
	#no checks on attack button
	buttons_to_enable.append(attack_button)
	
	#utility button
	var utils = get_tree().get_nodes_in_group("utilities")
	var available_utils : Array
	for util in utils:
		if not util.queued:
			available_utils.append(util)
	if available_utils.size() < 1:
		buttons_to_disable.append(utility_button)
	elif player.dropped_utilities.size() < 1:
		buttons_to_disable.append(utility_button)
	else:
		buttons_to_enable.append(utility_button)
	
	#TODO: item button
	buttons_to_enable.append(item_button)
	
	#no checks on special button
	buttons_to_enable.append(special_button)
	
	#end turn button
	if player.queued_actions.size() < 1:
		buttons_to_disable.append(end_turn_button)
	else:
		buttons_to_enable.append(end_turn_button)
	
	#enable or disable action menu buttons
	for button in buttons_to_enable:
		button.disabled = false
		button.set_focus_mode(Control.FOCUS_ALL)
	for button in buttons_to_disable:
		button.disabled = true
		button.set_focus_mode(Control.FOCUS_NONE)


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
	
func _on_player_actions_increased(number_of_actions):
	var icon = action_ready_icons[number_of_actions - 1]
	if icon:
		icon.activate()

func _on_attack_button_pressed():
	SoundPlayer.play_sound(SoundPlayer.MENU_SELECT)
	button_press_sequence.append(attack_button)
	for button in actions_container.get_children():
		button.set_focus_mode(Control.FOCUS_NONE)
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
	for button in actions_container.get_children():
		button.set_focus_mode(Control.FOCUS_NONE)
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

#called when action setup is canceled
func _on_combat_manager_action_setup_canceled():
	action_menu.show()
	var button = button_press_sequence.pop_back()
	button.grab_focus()

#called when turn phase starts
func _on_combat_manager_turn_phase_started(player : Player):
	update_buttons(player)
	overlay.show()
	action_menu.show()
	attacks_container.hide()
	specials_container.hide()
	attack_button.grab_focus()

#called when turn phase ends
func _on_combat_manager_turn_phase_ended():
	for icon in action_ready_icons:
		icon.deactivate()
	button_press_sequence.clear()
	action_bar.reset()
	overlay.hide()
	
#called after queuing action but not ending turn
func _on_combat_manager_action_queued(player : Player):
	var icon = action_ready_icons[player.max_actions_this_turn - player.queued_actions.size()]
	icon.deactivate()
	update_buttons(player)
	action_menu.show()
	button_press_sequence.clear()
	attacks_container.hide()
	specials_container.hide()
	attack_button.grab_focus()

#called when combat is over
func _on_combat_manager_combat_ended():
	action_bar.reset()
