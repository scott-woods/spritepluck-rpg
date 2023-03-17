extends Node2D


@onready var player = $Player
@onready var camera = $Camera2D
@onready var npc_remote : RemoteTransform2D = $TestNPC/RemoteTransform2D

func _input(event):
	if event.is_action_pressed("tab"):
		npc_remote.remote_path = camera.get_path()
