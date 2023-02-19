class_name Textbox
extends PanelContainer


signal finished_reading

@onready var texture : TextureRect = $Texture
@onready var sprite : TextureRect = $MarginContainer/HBoxContainer/Sprite
@onready var dialogue_label : RichTextLabel = $MarginContainer/HBoxContainer/DialogueLabel

var dialogue_resource : Resource
var text_delay = 0.035
var comma_delay = 0.2
var text_sound = SoundPlayer.DEFAULT_TEXT

#pass in a dialogue resource and initial title
func read(dialogue_resource, dialogue_title):
	TextboxManager.textbox = self
	
	#show dialogue label
	dialogue_label.show()
	
	#set dialogue resource
	self.dialogue_resource = dialogue_resource
	
	#get first line
	var line = await dialogue_resource.get_next_dialogue_line(dialogue_title)
	
	#loop until no more lines
	while line:
		#get sprite if necessary
#		if line.character:
#			var character_name #name of the character
#			var portrait_name #name of the portrait to use for this line
#
#			#portrait names should be after /
#			var index = line.character.find('/')
#			if index == -1:
#				#no / found, character name is full line
#				character_name = line.character
#				sprite.texture = null
#				sprite.hide()
#			else:
#				#/ found, try to load portrait sprite
#				character_name = line.character.substr(0, index)
#				portrait_name = line.character.substr(index + 1)
#				var portrait = load("res://entities/npcs/%s/portraits/%s.png" % [character_name.to_lower(), portrait_name.to_lower()])
#				if portrait:
#					#portrait sprite loaded, set and show sprite
#					sprite.texture = portrait
#					sprite.show()
#				else:
#					#portrait sprite not found, hide sprite
#					print("Portrait not found")
#					sprite.hide()
#		else:
#			sprite.hide()
		
		#dialogue label reading line
		dialogue_label.dialogue_line = line
		dialogue_label.type_out()
		await dialogue_label.finished_typing
		
		#waiting for player to press accept to continue
		while not Input.is_action_just_pressed("ui_accept"):
			await get_tree().process_frame
			
		#get next line
		line = await dialogue_resource.get_next_dialogue_line(line.next_id)
	
	#no more lines, end interaction
	emit_signal("finished_reading")

#called every time dialogue label shows a letter
func _on_dialogue_label_spoke(letter, letter_index, speed):
	if letter not in [' ', '.']:
		SoundPlayer.play_sound(text_sound)
	if letter == ',':
		await get_tree().create_timer(comma_delay).timeout
