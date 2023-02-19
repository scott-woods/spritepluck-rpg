extends Node


const TYLER_YES = preload("res://assets/sounds/yes.wav")
const PLAYER_HURT = preload("res://assets/sounds/player_hurt.wav")
const DASH_ATTACK = preload("res://assets/sounds/dash_attack.wav")
const USE_TELEPORTER = preload("res://assets/sounds/use_teleporter.wav")
const HEAL = preload("res://assets/sounds/heal.wav")
const ENEMY_HURT = preload("res://assets/sounds/enemy_hurt.wav")
const MENU_MOVE = preload("res://assets/sounds/menu_move.wav")
const MENU_SELECT = preload("res://assets/sounds/menu_select.wav")
const ACTION_BAR_READY = preload("res://assets/sounds/yes.wav")
const DEFAULT_TEXT = preload("res://assets/sounds/yes.wav")
const SQUEESH = preload("res://assets/sounds/squeesh.wav")
const TEST_NPC_TEXT = preload("res://assets/sounds/squeesh.wav")

@onready var audio_players = $AudioPlayers

func play_sound(sound):
	var audio_player = AudioStreamPlayer.new()
	audio_player.bus = "Sound"
	audio_players.add_child(audio_player)
	audio_player.stream = sound
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()
