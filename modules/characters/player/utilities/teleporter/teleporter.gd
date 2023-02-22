class_name Teleporter
extends Utility


func _ready():
	projected_player_position = position

func trigger():
	SoundPlayer.play_sound(SoundPlayer.USE_TELEPORTER)
	player.global_position = global_position
	emit_signal("trigger_completed")
