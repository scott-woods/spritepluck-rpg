class_name DefaultUI
extends CanvasLayer


@onready var textbox : Textbox = $Container/MarginContainer/Textbox

func setup(interactables : Array):
	for interactable in interactables:
		interactable.interaction_started.connect(_on_interactable_interaction_started)


func _on_interactable_interaction_started(dialogue : DialogueResource, dialogue_title : String):
	textbox.show()
	await textbox.read(dialogue, dialogue_title)
	textbox.hide()
