class_name DungeonRoomComponent
extends Node


@export var top_door : DungeonRoomDoor
@export var bottom_door : DungeonRoomDoor
@export var left_door : DungeonRoomDoor
@export var right_door : DungeonRoomDoor

func _ready():
	var owner = get_parent()
	var room_data = owner.room_data
	if top_door:
		top_door.move_to_coordinates = room_data.top_door_coordinates
	if bottom_door:
		bottom_door.move_to_coordinates = room_data.bottom_door_coordinates
	if left_door:
		left_door.move_to_coordinates = room_data.left_door_coordinates
	if right_door:
		right_door.move_to_coordinates = room_data.right_door_coordinates
