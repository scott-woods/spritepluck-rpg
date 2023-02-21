extends Node


@export var TYLER_YES : AudioStream
@export var PLAYER_HURT : AudioStream
@export var DASH_ATTACK : AudioStream
@export var USE_TELEPORTER : AudioStream
@export var HEAL : AudioStream
@export var ENEMY_HURT : AudioStream
@export var MENU_MOVE : AudioStream
@export var MENU_SELECT : AudioStream
@export var ACTION_BAR_READY : AudioStream
@export var DEFAULT_TEXT : AudioStream
@export var SQUEESH : AudioStream
@export var TEST_NPC_TEXT : AudioStream

@onready var audio_players = $AudioPlayers

func play_sound(sound):
	var audio_player = AudioStreamPlayer.new()
	audio_player.bus = "Sound"
	audio_players.add_child(audio_player)
	audio_player.stream = sound
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()
