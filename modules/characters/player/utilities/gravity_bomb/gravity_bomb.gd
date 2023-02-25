class_name GravityBomb
extends Utility


@onready var radius_sprite : Sprite2D = $Radius
@onready var effect_area : Area2D = $EffectArea

const TIME : float = .5
const PULL_SPEED : float = 125

func trigger():	
	var timer = get_tree().create_timer(TIME)
	while timer.time_left > 0:
		var enemies = effect_area.get_overlapping_bodies()
		for enemy in enemies:
			var dir = enemy.position.direction_to(position)
			if enemy.position.distance_to(position) > 0:
				enemy.velocity += dir * PULL_SPEED
				enemy.move_and_slide()
		await get_tree().physics_frame
	emit_signal("trigger_completed")
