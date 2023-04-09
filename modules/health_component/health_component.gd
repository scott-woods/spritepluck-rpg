class_name HealthComponent
extends Node2D


signal hp_depleted

@export var max_hp : int
@export var hp : int

func damage(amount : int):
	hp = clamp(hp - amount, 0, max_hp)
	check_for_depleted_hp()
		
func heal(amount : int):
	hp = clamp(hp + amount, 0, max_hp)
	check_for_depleted_hp()
	
func check_for_depleted_hp():
	if hp == 0:
		emit_signal("hp_depleted")
