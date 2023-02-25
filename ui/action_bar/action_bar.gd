class_name ActionBar
extends ProgressBar


@onready var animation_player : AnimationPlayer = $AnimationPlayer

func flash():
	animation_player.play("ACTION_BAR_FLASH")

func reset():
	animation_player.play("RESET")
	value = 0
