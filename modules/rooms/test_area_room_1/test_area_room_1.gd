extends Room


@export var top_door : DungeonRoomDoor
@export var bottom_door : DungeonRoomDoor
@export var left_door : DungeonRoomDoor
@export var right_door : DungeonRoomDoor

@onready var combat_manager : CombatManager = $CombatManager
@onready var player_spawner : PlayerSpawner = $PlayerSpawner

var room_data : DungeonRoomData = DungeonRoomData.new()

func init(data : DungeonRoomData):
	if data:
		room_data = data

# Called when the node enters the scene tree for the first time.
func _ready():	
	if top_door:
		top_door.move_to_coordinates = room_data.top_door_coordinates
	if bottom_door:
		bottom_door.move_to_coordinates = room_data.bottom_door_coordinates
	if left_door:
		left_door.move_to_coordinates = room_data.left_door_coordinates
	if right_door:
		right_door.move_to_coordinates = room_data.right_door_coordinates
	
	player = Game.player
	player.utility_dropped.connect(_on_player_utility_dropped)
	
	camera = Game.camera
	super()

func start():
	player_spawner.spawn_player()
	camera.set_target(player, true)
	
	if SceneManager.transitioning:
		await SceneManager.scene_change_finished

	if room_data.room_cleared == false:
		combat_manager.start_combat()
	else:
		remove_walls()

func remove_walls():
	var removable_walls = get_tree().get_nodes_in_group("removable_walls")
	for wall in removable_walls:
		wall.collision.set_deferred("disabled", true)


func _on_combat_manager_combat_ended():
	room_data.room_cleared = true
	remove_walls()
