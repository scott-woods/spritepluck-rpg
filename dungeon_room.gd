class_name DungeonRoom
extends Resource


enum ROOM_TYPE {ENCOUNTER, EVENT, PUZZLE, SHOP, MINI_BOSS, BOSS}

@export var room_type : ROOM_TYPE
@export var room_scene : PackedScene
@export var has_top_door : bool
@export var has_bottom_door : bool
@export var has_left_door : bool
@export var has_right_door : bool

var number_of_doors : int:
	set(value):
		number_of_doors = value
	get:
		var num = 0
		if has_top_door:
			num += 1
		if has_bottom_door:
			num += 1
		if has_left_door:
			num += 1
		if has_right_door:
			num += 1
		return num
