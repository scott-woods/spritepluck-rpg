extends MiscAction


func _ready():
	label = "Heal"
	type = "MISC"

func setup(simulation_player):
	emit_signal("setup_finished", true)

func execute():
	SoundPlayer.play_sound(SoundPlayer.HEAL)
	player.stats.hp += 1
	if player.stats.hp > player.stats.max_hp:
		player.stats.hp = player.stats.max_hp
	player.emit_signal("health_changed", player.stats.hp)
	player.sprite.modulate = Color.LIGHT_GREEN
	await get_tree().create_timer(.25).timeout
	player.sprite.modulate = Color.WHITE
