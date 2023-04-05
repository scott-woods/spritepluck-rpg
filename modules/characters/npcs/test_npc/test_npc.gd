class_name TestNPC
extends StaticBody2D


const Textbox : PackedScene = preload("res://ui/textbox/textbox.tscn")

@export var Bad : DialogueResource

@onready var sprite : Sprite2D = $Sprite
@onready var collision : CollisionShape2D = $Collision
@onready var interactable : Interactable = $Interactable

var times_interacted : int = 0

func _on_interactable_interaction_started():
	#create textbox
	var textbox = Textbox.instantiate()
	add_child(textbox)
	
	#determine which part of dialogue to read
	var dialogue_title : String
	match times_interacted:
		0:
			dialogue_title = "bad"
		1:
			dialogue_title = "bad_2"
		_:
			dialogue_title = "repeating"
			
	#read dialogue
	await textbox.read(Bad, dialogue_title)
	
	#free textbox
	textbox.queue_free()
	
	#finish interaction
	times_interacted += 1
	interactable.finish_interaction()
