extends Node


var current_area_data : Area
var rooms_cleared : int = 0

#called when first entering an area
func start(area_data : Area, target_spawn : String):
	#set area data
	current_area_data = area_data
	
	#get first random room
	var room_scene = area_data.rooms[randi_range(0, area_data.rooms.size() - 1)]
	var room = room_scene.instantiate()
	SceneManager.change_scene(room, target_spawn)
	await SceneManager.scene_change_finished
	
	#init exits in new room
	init_exits()
	
	#start music
	if area_data.music:
		MusicPlayer.play_music(area_data.music)

#populate exit areas of next room
func init_exits():
	for exit in get_tree().get_nodes_in_group("exit_areas"):
		exit.target_scene = current_area_data.rooms[randi_range(0, current_area_data.rooms.size() -1)]
		exit.connect("exited", _on_room_exited)


#called when dungeon room is exited
func _on_room_exited(target_spawn : String):
	rooms_cleared += 1
	await SceneManager.scene_change_finished
	init_exits()
