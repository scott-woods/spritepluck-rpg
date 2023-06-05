class_name RangerCombat
extends RangerState
	

const MIN_DISTANCE_FROM_PLAYER : int = 150
const MAX_DISTANCE_FROM_PLAYER : int = 225
const DIRECTIONS : Array = [
	Vector2(0, -1), Vector2(1, -1), Vector2(1, 0), Vector2(1, 1),
	Vector2(0, 1), Vector2(-1, 1), Vector2(-1, 0), Vector2(-1, -1)
	]

@onready var action_timer : Timer = $ActionTimer

var original_speed : int

func _ready():
	super()
	await owner.ready
	original_speed = ranger.velocity_component.speed

func physics_update(delta):
	var target : Vector2
	var direction = ranger.player.global_position.direction_to(ranger.global_position)
	var dist_to_player = ranger.global_position.distance_to(ranger.player.global_position)
	if dist_to_player > MAX_DISTANCE_FROM_PLAYER:
		ranger.velocity_component.speed = original_speed
		if !action_timer.is_stopped():
			action_timer.stop()
		target = ranger.player.global_position
	elif dist_to_player < MIN_DISTANCE_FROM_PLAYER:
		ranger.velocity_component.speed = original_speed
		if !action_timer.is_stopped():
			action_timer.stop()
		var nav_regions = get_tree().get_nodes_in_group("nav_regions")
		var target_options : Array
		for dir in DIRECTIONS:
			#point that is min distance away from player in this direction
			var point = Game.player.global_position + (dir * MIN_DISTANCE_FROM_PLAYER)
			#check that point is in nav region
			var filtered_regions = nav_regions.filter(
				func(r):
					var polygon : NavigationPolygon = r.navigation_polygon
					var vector_array = polygon.vertices
					if Geometry2D.is_point_in_polygon(point, vector_array):
						return true
			)
			if filtered_regions.size() > 0:
				#point is in nav region, add as option
				target_options.append(point)
			else:
				#if there are any valid options and this one isn't, throw it out
				if target_options.any(func(o): return o.distance_to(Game.player.global_position) == MIN_DISTANCE_FROM_PLAYER):
					continue
				else:
					var intersect_point : Vector2
					for region in nav_regions:
						var polygon : NavigationPolygon = region.navigation_polygon
						var vertices : PackedVector2Array = polygon.vertices
						for i in vertices.size() - 1:
							var vertex_1 = vertices[i]
							var next_idx = i + 1
							if next_idx == vertices.size():
								next_idx = 0
							var vertex_2 = vertices[next_idx]
							var intersect = Geometry2D.segment_intersects_segment(vertex_1, vertex_2, Game.player.global_position, point)
							if intersect != null:
								if intersect.distance_to(Game.player.global_position) < intersect_point.distance_to(Game.player.global_position):
									intersect_point = intersect
					target_options.append(intersect_point)
		var best_option_diff : float = 0
		for option in target_options:
			var option_dist_to_player = option.distance_to(Game.player.global_position)
			var option_dist_to_agent = option.distance_to(ranger.global_position)
			var diff = option_dist_to_player - option_dist_to_agent
			if diff > best_option_diff:
				target = option
	else:
		ranger.velocity_component.speed = original_speed / 2
		if action_timer.is_stopped():
			action_timer.start()
		var is_target_valid : bool = false
		while is_target_valid == false:
			var rand_dir = Vector2.from_angle(deg_to_rad(randi_range(0, 360)))
			target = ranger.global_position + (rand_dir * 25)
			if target.distance_to(Game.player.global_position) > MAX_DISTANCE_FROM_PLAYER:
				is_target_valid = false
			elif target.distance_to(Game.player.global_position) < MIN_DISTANCE_FROM_PLAYER:
				is_target_valid = false
			else:
				is_target_valid = true
	
	ranger.pathfinding_component.set_target_position(target)
	ranger.pathfinding_component.follow_path()
	ranger.velocity_component.move(ranger)


func _on_action_timer_timeout():
	ranger.state_machine.change_state("RangerExecutingAction")
	await ranger.snipe.execute()
	await get_tree().create_timer(ranger.ACTION_COOLDOWN).timeout
	ranger.state_machine.change_state("RangerCombat")
