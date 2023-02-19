extends Node


var textbox : Textbox

var portrait:
	set(new_portrait):
		portrait = new_portrait
		textbox.sprite.texture = portrait
		if portrait:
			textbox.sprite.show()
		else:
			textbox.sprite.hide()
	get:
		return portrait

var font:
	set(new_font):
		font = new_font
		textbox.theme.set_font("normal_font", "RichTextLabel", font)
	get:
		return font

var sound:
	set(new_sound):
		sound = new_sound
		textbox.text_sound = sound
	get:
		return sound
