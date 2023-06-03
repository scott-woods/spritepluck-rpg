class_name DungeonRoom
extends Resource


enum ROOM_TYPE {ENCOUNTER, EVENT, PUZZLE, SHOP, MINI_BOSS, BOSS}

@export var room_type : ROOM_TYPE
@export var room_scene : PackedScene
@export var has_top_door : bool
@export var has_bottom_door : bool
@export var has_left_door : bool
@export var has_right_door : bool
