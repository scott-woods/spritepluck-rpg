class_name Dungenerator
extends Node


var dungeon_map : Array[DungeonMapNode]
var max_rooms : int = 20
var incoming_scene : PackedScene
	
func generate_dungeon(area_data : Resource, incoming_direction : String, incoming_scene : PackedScene):
	self.incoming_scene = incoming_scene
	var depth = 0
	var coordinates = Vector2.ZERO
	get_next_node(area_data, incoming_direction, depth, coordinates)
	#use map to set scene value for each node's doors
#	for node in dungeon_map:
#		node = node as DungeonMapNode
#		if node.dungeon_room.has_top_door:
#			var matched_nodes = dungeon_map.filter(func(n): return n.coordinates == node.coordinates + Vector2(0, -1))
#			if matched_nodes.size() > 0:
#				var scene = matched_nodes[0].dungeon_room.room_scene
#				node.dungeon_room_data.top_door_scene = scene
#		if node.dungeon_room.has_bottom_door:
#			var matched_nodes = dungeon_map.filter(func(n): return n.coordinates == node.coordinates + Vector2(0, 1))
#			if matched_nodes.size() > 0:
#				var scene = matched_nodes[0].dungeon_room.room_scene
#				node.dungeon_room_data.bottom_door_scene = scene
#		if node.dungeon_room.has_left_door:
#			var matched_nodes = dungeon_map.filter(func(n): return n.coordinates == node.coordinates + Vector2(-1, 0))
#			if matched_nodes.size() > 0:
#				var scene = matched_nodes[0].dungeon_room.room_scene
#				node.dungeon_room_data.left_door_scene = scene
#		if node.dungeon_room.has_right_door:
#			var matched_nodes = dungeon_map.filter(func(n): return n.coordinates == node.coordinates + Vector2(1, 0))
#			if matched_nodes.size() > 0:
#				var scene = matched_nodes[0].dungeon_room.room_scene
#				node.dungeon_room_data.right_door_scene = scene
	return dungeon_map

func get_next_node(area_data : Resource, incoming_direction : String, depth : int, coordinates : Vector2):
	#create new map node
	var node = DungeonMapNode.new()
	node.depth = depth
	node.coordinates = coordinates
	
	#chances dictionary
	var chances : Dictionary = {
		"encounter": 1,
		"event": 0,
		"puzzle": 0,
		"shop": 0,
		"mini_boss": 0,
		"boss": 0
	}
	
	#get chances for room type by depth and other factors
	match depth:
		0:
			chances.encounter = 1
		1:
			chances.encounter = 1
			chances.puzzle = 0
		2:
			for chance in chances:
				chances[chance] = 0
			chances.boss = 1
			
	#get room type based on percent chance
	var rand = randf()
	var prob = 1
	var room_type : DungeonRoom.ROOM_TYPE
	for chance in chances:
		prob = prob - chances[chance]
		if rand >= prob:
			match chance:
				"encounter":
					room_type = DungeonRoom.ROOM_TYPE.ENCOUNTER
				"event":
					room_type = DungeonRoom.ROOM_TYPE.EVENT
				"puzzle":
					room_type = DungeonRoom.ROOM_TYPE.PUZZLE
				"shop":
					room_type = DungeonRoom.ROOM_TYPE.SHOP
				"mini_boss":
					room_type = DungeonRoom.ROOM_TYPE.MINI_BOSS
				"boss":
					room_type = DungeonRoom.ROOM_TYPE.BOSS
			break
	
	#pick random room by type
	var filtered_rooms = area_data.dungeon_rooms.filter(
		func(r):
			#filter by room type
			if r.room_type != room_type:
				return false
			#room has door that matches incoming direction
			match incoming_direction:
				"from_top":
					if r.has_bottom_door == false:
						return false
				"from_bottom":
					if r.has_top_door == false:
						return false
				"from_left":
					if r.has_right_door == false:
						return false
				"from_right":
					if r.has_left_door == false:
						return false
			#validate that no doors lead to rooms without a matching doorway
			if r.has_top_door:
				var matched_nodes = dungeon_map.filter(func(n): return n.coordinates == node.coordinates + Vector2(0, -1))
				if matched_nodes:
					var matched_node = matched_nodes[0]
					if matched_node.dungeon_room.has_bottom_door == false:
						return false
			if r.has_bottom_door:
				var matched_nodes = dungeon_map.filter(func(n): return n.coordinates == node.coordinates + Vector2(0, 1))
				if matched_nodes:
					var matched_node = matched_nodes[0]
					if matched_node.dungeon_room.has_top_door == false:
						return false
			if r.has_left_door:
				var matched_nodes = dungeon_map.filter(func(n): return n.coordinates == node.coordinates + Vector2(-1, 0))
				if matched_nodes:
					var matched_node = matched_nodes[0]
					if matched_node.dungeon_room.has_right_door == false:
						return false
			if r.has_right_door:
				var matched_nodes = dungeon_map.filter(func(n): return n.coordinates == node.coordinates + Vector2(1, 0))
				if matched_nodes:
					var matched_node = matched_nodes[0]
					if matched_node.dungeon_room.has_left_door == false:
						return false
						
			#all filters passed, return true
			return true
	)
	if filtered_rooms.size() < 1:
		var room = area_data.dungeon_rooms.filter(func(r): return r.room_type == DungeonRoom.ROOM_TYPE.BOSS)[0]
		node.dungeon_room = room
		var scene = node.dungeon_room.room_scene.instantiate()
		node.dungeon_room_data = scene.room_data
		scene.queue_free()
	else:
		var room = filtered_rooms.pick_random()
		var scene = room.room_scene.instantiate()
		node.dungeon_room = room
		node.dungeon_room_data = scene.room_data
		scene.queue_free()
	
	#add to dungeon map
	dungeon_map.append(node)
	
	#get nodes for the exits in the new node
	if node.dungeon_room.room_type == DungeonRoom.ROOM_TYPE.BOSS:
		var new_coords : Vector2
		match incoming_direction:
			"from_top":
				new_coords = node.coordinates + Vector2(0, 1)
			"from_bottom":
				new_coords = node.coordinates + Vector2(0, -1)
			"from_left":
				new_coords = node.coordinates + Vector2(1, 0)
			"from_right":
				new_coords = node.coordinates + Vector2(-1, 0)
		node.dungeon_room_data.bottom_door_coordinates = new_coords
	if node.dungeon_room.room_type != DungeonRoom.ROOM_TYPE.BOSS:
		if node.dungeon_room.has_bottom_door:
			if node.coordinates == Vector2.ZERO and incoming_direction == "from_top":
				node.dungeon_room_data.bottom_door_scene = incoming_scene
			else:
				var new_coords = node.coordinates + Vector2(0, 1)
				node.dungeon_room_data.bottom_door_coordinates = new_coords
				var matched_nodes = dungeon_map.filter(func(n): return n.coordinates == new_coords)
				if matched_nodes.is_empty():
					get_next_node(area_data, "from_bottom", node.depth + 1, new_coords)
		if node.dungeon_room.has_top_door:
			if node.coordinates == Vector2.ZERO and incoming_direction == "from_bottom":
				node.dungeon_room_data.top_door_scene = incoming_scene
			else:
				var new_coords = node.coordinates + Vector2(0, -1)
				node.dungeon_room_data.top_door_coordinates = new_coords
				var matched_nodes = dungeon_map.filter(func(n): return n.coordinates == new_coords)
				if matched_nodes.is_empty():
					get_next_node(area_data, "from_top", node.depth + 1, new_coords)
		if node.dungeon_room.has_left_door:
			if node.coordinates == Vector2.ZERO and incoming_direction == "from_right":
				node.dungeon_room_data.left_door_scene = incoming_scene
			else:
				var new_coords = node.coordinates + Vector2(-1, 0)
				node.dungeon_room_data.left_door_coordinates = new_coords
				var matched_nodes = dungeon_map.filter(func(n): return n.coordinates == new_coords)
				if matched_nodes.is_empty():
					get_next_node(area_data, "from_left", node.depth + 1, new_coords)
		if node.dungeon_room.has_right_door:
			if node.coordinates == Vector2.ZERO and incoming_direction == "from_left":
				node.dungeon_room_data.right_door_scene = incoming_scene
			else:
				var new_coords = node.coordinates + Vector2(1, 0)
				node.dungeon_room_data.right_door_coordinates = new_coords
				var matched_nodes = dungeon_map.filter(func(n): return n.coordinates == new_coords)
				if matched_nodes.is_empty():
					get_next_node(area_data, "from_right", node.depth + 1, new_coords)
