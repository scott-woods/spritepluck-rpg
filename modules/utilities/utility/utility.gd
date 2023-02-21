class_name Utility
extends Node2D


signal trigger_completed

@onready var sprite : Sprite2D = $Sprite

var player : Player
var queued : bool = false
var projected_player_position : Vector2

func init(player : Player):
	self.player = player

func focus():
	#utility focused while player is selecting utility to use
	pass
	
func unfocus():
	#focus left utility while player is selecting utility to use
	pass

func trigger():
	#trigger effect
	pass
