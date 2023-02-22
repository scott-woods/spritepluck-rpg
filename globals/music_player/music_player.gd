extends Node


@export var SPICY : AudioStream

const MIN_FILTER_CUTOFF_HZ := 2500
const MAX_FILTER_CUTOFF_HZ := 8000
const MIN_FILTER_RES := .5
const MAX_FILTER_RES := 1
const FILTER_SPEED := .25

@onready var audio_stream_player : AudioStreamPlayer = $AudioStreamPlayer

func play_music(music):
	audio_stream_player.stream = music
	audio_stream_player.play()

func apply_filter():
	AudioServer.set_bus_effect_enabled(2, 0, true)
	var filter = AudioServer.get_bus_effect(2, 0) as AudioEffectFilter
	var cutoff_tween = create_tween()
	cutoff_tween.tween_property(filter, "cutoff_hz", MIN_FILTER_CUTOFF_HZ, FILTER_SPEED)
	var res_tween = create_tween()
	res_tween.tween_property(filter, "resonance", MIN_FILTER_RES, FILTER_SPEED)
	
func disable_filter():
	var filter = AudioServer.get_bus_effect(2, 0) as AudioEffectFilter
	var cutoff_tween = create_tween()
	cutoff_tween.tween_property(filter, "cutoff_hz", MAX_FILTER_CUTOFF_HZ, FILTER_SPEED)
	var res_tween = create_tween()
	res_tween.tween_property(filter, "resonance", MAX_FILTER_RES, FILTER_SPEED)
	AudioServer.set_bus_effect_enabled(2, 0, false)

func stop_music():
	if audio_stream_player.playing:
		audio_stream_player.stop()
