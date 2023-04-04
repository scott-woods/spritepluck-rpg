extends Node


var current_area_data : Area
var rooms_cleared : int = 0

#called when first entering an area
func start(area_data : Area, target_spawn : String):
	reset()
	current_area_data = area_data
	var room = area_data.rooms[randi_range(0, area_data.rooms.size() - 1)]
	SceneManager.change_scene(room, target_spawn)
	await SceneManager.scene_change_finished
	if area_data.music:
		MusicPlayer.play_music(area_data.music)

#pick next room
func get_next_room(target_spawn : String):
	var room_scene = current_area_data.rooms[randi_range(0, current_area_data.rooms.size() - 1)]
	SceneManager.change_scene(room_scene, target_spawn)

func increment_rooms_cleared(room):
	rooms_cleared += 1

func reset():
	rooms_cleared = 0
