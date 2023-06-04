class_name DungeonRoomDoor
extends Node2D


signal entered(node : DungeonMapNode, target_spawn : String)
signal dungeon_exit_entered(target_scene : PackedScene, target_spawn : String)

@export var target_spawn : String

@onready var area : Area2D = $Area
@onready var collision : CollisionShape2D = $Area/Collision


var node : DungeonMapNode
var target_scene : PackedScene
var is_dungeon_exit : bool = false


func _on_area_body_entered(body):
	if !is_dungeon_exit:
		emit_signal("entered", node, target_spawn)
	else:
		emit_signal("dungeon_exit_entered", target_scene, target_spawn)
