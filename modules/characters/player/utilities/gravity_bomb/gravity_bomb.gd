class_name GravityBomb
extends Utility


@onready var radius_sprite : Sprite2D = $Radius
@onready var effect_area : Area2D = $EffectArea
@onready var timer : Timer = $Timer

const TIME : float = .5
const PULL_SPEED : float = 200

var active : bool = false

func _physics_process(delta):
	if active:
		var util_effect_components = effect_area.get_overlapping_areas()
		for util_effect_component in util_effect_components:
			util_effect_component = util_effect_component as UtilityEffectsComponent
			util_effect_component.trigger_gravity_bomb_effect(self, delta)
#		var enemies = effect_area.get_overlapping_bodies()
#		for enemy in enemies:
#			if not enemy.stats.grounded:
#				var direction = enemy.position.direction_to(position)
#				if enemy.position.distance_to(position) > 0:
#					enemy.position += direction * PULL_SPEED * delta

func trigger():
	active = true
	timer.start()
	emit_signal("trigger_completed")
#	var timer = get_tree().create_timer(TIME)
#	while timer.time_left > 0:
#		var enemies = effect_area.get_overlapping_bodies()
#		for enemy in enemies:
#			var dir = enemy.position.direction_to(position)
#			if enemy.position.distance_to(position) > 0:
#				enemy.velocity += dir * PULL_SPEED
#		await get_tree().physics_framez
#	emit_signal("trigger_completed")


func _on_timer_timeout():
	active = false
