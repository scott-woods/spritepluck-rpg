class_name DungeonRoomComponent
extends Node


@export var top_door : DungeonRoomDoor
@export var bottom_door : DungeonRoomDoor
@export var left_door : DungeonRoomDoor
@export var right_door : DungeonRoomDoor
@export var combat_manager : CombatManager

var room_data : DungeonRoomData

func _ready():
	var owner = get_parent()
	room_data = owner.room_data
	if top_door:
		top_door.node = room_data.top_door_node
		top_door.target_scene = room_data.top_door_scene
		top_door.is_dungeon_exit = room_data.top_door_is_exit
	if bottom_door:
		bottom_door.node = room_data.bottom_door_node
		bottom_door.target_scene = room_data.bottom_door_scene
		bottom_door.is_dungeon_exit = room_data.bottom_door_is_exit
	if left_door:
		left_door.node = room_data.left_door_node
		left_door.target_scene = room_data.left_door_scene
		left_door.is_dungeon_exit = room_data.left_door_is_exit
	if right_door:
		right_door.node = room_data.right_door_node
		right_door.target_scene = room_data.right_door_scene
		right_door.is_dungeon_exit = room_data.right_door_is_exit

	#disable walls if room is already cleared
	if room_data.room_cleared:
		disable_walls()
	
	#connect to combat manager
	if combat_manager:
		combat_manager.combat_ended.connect(_on_combat_manager_combat_ended)
	
func disable_walls():
	var removable_walls = get_tree().get_nodes_in_group("removable_walls")
	for wall in removable_walls:
		wall.disable()
	
	
func _on_combat_manager_combat_ended():
	disable_walls()
	room_data.room_cleared = true
