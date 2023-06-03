class_name DungeonRoom
extends Resource


enum ROOM_TYPE {ENCOUNTER, EVENT, PUZZLE, SHOP, MINI_BOSS, BOSS}

@export var room_type : ROOM_TYPE
@export var room_scene : PackedScene
