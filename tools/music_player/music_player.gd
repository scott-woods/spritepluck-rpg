extends Node


const SPICY = "res://assets/music/spicy.ogg"

@onready var audio_stream_player : AudioStreamPlayer = $AudioStreamPlayer

@export var min_filter_cutoff_hz := 2500
@export var max_filter_cutoff_hz := 8000
@export var min_filter_res := .5
@export var max_filter_res := 1
@export var filter_speed := .25

func play_music(music):
	var stream = load(music)
	audio_stream_player.stream = stream
	audio_stream_player.play()

func apply_filter():
	AudioServer.set_bus_effect_enabled(2, 0, true)
	var filter = AudioServer.get_bus_effect(2, 0) as AudioEffectFilter
	var cutoff_tween = create_tween()
	cutoff_tween.tween_property(filter, "cutoff_hz", min_filter_cutoff_hz, filter_speed)
	var res_tween = create_tween()
	res_tween.tween_property(filter, "resonance", min_filter_res, filter_speed)
	
func disable_filter():
	var filter = AudioServer.get_bus_effect(2, 0) as AudioEffectFilter
	var cutoff_tween = create_tween()
	cutoff_tween.tween_property(filter, "cutoff_hz", max_filter_cutoff_hz, filter_speed)
	var res_tween = create_tween()
	res_tween.tween_property(filter, "resonance", max_filter_res, filter_speed)
	AudioServer.set_bus_effect_enabled(2, 0, false)

func stop_music():
	if audio_stream_player.playing:
		audio_stream_player.stop()
