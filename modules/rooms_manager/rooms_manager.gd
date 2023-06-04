class_name RoomsManager
extends Node


@onready var dungenerator : Dungenerator = $Dungenerator

var current_area_data : Area
var rooms_cleared : int = 0
var dungeon_map : Array[DungeonMapNode]
var current_node : DungeonMapNode
var incoming_scene : PackedScene

#called when first entering an area
func start(area_data : Resource, target_spawn : String, incoming_scene_path : String):
	#set area data
	current_area_data = area_data
	
	#set incoming scene
	incoming_scene = load(incoming_scene_path)
	
	#generate dungeon and get dungeon map
	dungeon_map = dungenerator.generate_dungeon(area_data, target_spawn, incoming_scene)
	
	#move to room with coordinates (0, 0) in map
	var filtered_nodes = dungeon_map.filter(func(n): return n.coordinates == Vector2.ZERO)
	var node = filtered_nodes[0]
	move_to_room(node, target_spawn)
	
#	#get first random room
#	var room_scene = area_data.rooms[randi_range(0, area_data.rooms.size() - 1)]
#	var room = room_scene.instantiate()
#	SceneManager.change_scene(room, target_spawn)
#	await SceneManager.scene_change_finished
#
#	#init exits in new room
#	init_exits()
	
	#start music
	if area_data.music:
		MusicPlayer.play_music(area_data.music)

func move_to_room(target_node : DungeonMapNode, target_spawn : String):
	var scene = target_node.dungeon_room.room_scene.instantiate()
	scene.init(target_node.dungeon_room_data)
	SceneManager.change_scene(scene, target_spawn)
	await SceneManager.scene_change_finished
	connect_to_doors()

func exit_dungeon(target_scene : PackedScene, target_spawn : String):
	var scene = target_scene.instantiate()
	SceneManager.change_scene(scene, target_spawn)
	MusicPlayer.stop_music()
	queue_free()

func connect_to_doors():
	for door in get_tree().get_nodes_in_group("dungeon_doors"):
		door.connect("entered", _on_door_entered)
		door.connect("dungeon_exit_entered", _on_door_dungeon_exit_entered)

#populate exit areas of next room
#func init_exits():
#	for exit in get_tree().get_nodes_in_group("exit_areas"):
#		exit.target_scene = current_area_data.rooms[randi_range(0, current_area_data.rooms.size() -1)]
#		exit.connect("exited", _on_room_exited)


func _on_door_entered(target_node : DungeonMapNode, target_spawn : String):
	rooms_cleared += 1
	move_to_room(target_node, target_spawn)
	
func _on_door_dungeon_exit_entered(target_scene : PackedScene, target_spawn : String):
	exit_dungeon(target_scene, target_spawn)

#called when dungeon room is exited
#func _on_room_exited(target_spawn : String):
#	rooms_cleared += 1
#	await SceneManager.scene_change_finished
#	init_exits()
