class_name TestNPC
extends StaticBody2D


signal interaction_finished

const Textbox : PackedScene = preload("res://ui/textbox/textbox.tscn")

@export var Bad : DialogueResource

@onready var sprite : Sprite2D = $Sprite
@onready var collision : CollisionShape2D = $Collision
@onready var interactable : Interactable = $Interactable

var interactions

#necessary injections
var default_ui : DefaultUI

func init(default_ui):
	self.default_ui = default_ui

func on_interact():
	default_ui.textbox.show()
	await default_ui.textbox.read(Bad, "bad")
	default_ui.textbox.hide()
	emit_signal("interaction_finished")
	#tell ui to show textbox
	#read text (optionally pass a sprite and custom sound)
	#wait until textbox emits finished signal
	#read next line, if necessary
	#when out of lines, emit interaction_finished signal
	#increment number of interactions (in a resource file)

func _on_interactable_interaction_started():
	var textbox = Textbox.instantiate()
	add_child(textbox)
