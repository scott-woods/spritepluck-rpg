class_name CombatButton
extends Button


var ap_cost : int

func _on_focus_entered():
	SoundPlayer.play_sound(SoundPlayer.MENU_MOVE)
