class_name Enemy
extends CharacterBody2D


signal died

func enter_combat_state():
	print("Missing override of the enter_combat_state method")
	return false

#func _ready():
#	stats = stats.copy()
#	health_bar.max_value = stats.max_hp
#	health_bar.value = stats.hp
#	setup_navigation()
#
#func setup_navigation():
#	await get_tree().physics_frame
#	navigation_agent.max_speed = stats.speed
#	navigation_agent.radius = max(sprite.get_rect().size.x, sprite.get_rect().size.y) / 2
#	navigation_agent.target_position = position
#
#func enter_combat_state():
#	if can_move:
#		state_machine.change_state("EnemyCombat/EnemyMoving")
#	else:
#		state_machine.change_state("EnemyCombat")
#
#func take_damage(amount):
#	SoundPlayer.play_sound(SoundPlayer.ENEMY_HURT)
#	stats.hp -= amount
#	if stats.hp <= 0:
#		stats.hp = 0
#	emit_signal("health_changed", stats.hp)
#	if stats.hp == 0:
#		die()
#	else:
#		hurtbox.collision.disabled = true
#		await get_tree().create_timer(stats.invincible_time).timeout
#		hurtbox.collision.disabled = false
