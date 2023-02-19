class_name Teleporter
extends StaticBody2D


signal trigger_completed

const label = "Teleporter"

var player : Player
var queued = false
var projected_player_position : Vector2
var moves_player : bool = true

func init(player):
	self.player = player
	
func _ready():
	projected_player_position = position

func trigger():
	SoundPlayer.play_sound(SoundPlayer.USE_TELEPORTER)
	player.global_position = global_position
	emit_signal("trigger_completed")
