class_name CharacterStats
extends Resource

@export var hp : int
@export var max_hp : int
@export var speed : int
@export var invincible_time : float

#Make a copy of this resource, so each new enemy gets a unique one
func copy() -> CharacterStats:
	var copy = duplicate()
	copy.hp = hp
	copy.max_hp = max_hp
	return copy
