class_name DungeonRoomDoor
extends Node2D


signal entered(target_coordinates : Vector2, target_scene : PackedScene, target_spawn : String)

@export var target_spawn : String

@onready var area : Area2D = $Area
@onready var collision : CollisionShape2D = $Area/Collision

var move_to_coordinates : Vector2
var target_scene : PackedScene


func _on_area_body_entered(body):
	emit_signal("entered", move_to_coordinates, target_scene, target_spawn)
