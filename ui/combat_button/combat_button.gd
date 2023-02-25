class_name CombatButton
extends Button


func _on_focus_entered():
	SoundPlayer.play_sound(SoundPlayer.MENU_MOVE)
