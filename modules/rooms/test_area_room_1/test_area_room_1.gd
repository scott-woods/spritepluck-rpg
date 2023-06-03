extends Room


@export var top_door : DungeonRoomDoor
@export var bottom_door : DungeonRoomDoor
@export var left_door : DungeonRoomDoor
@export var right_door : DungeonRoomDoor

@onready var combat_manager : CombatManager = $CombatManager
@onready var player_spawner : PlayerSpawner = $PlayerSpawner

var room_cleared : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = Game.player
	player.utility_dropped.connect(_on_player_utility_dropped)
	
	camera = Game.camera
	super()

func start():
	player_spawner.spawn_player()
	camera.set_target(player, true)
	
	if SceneManager.transitioning:
		await SceneManager.scene_change_finished

	combat_manager.start_combat()


func _on_combat_manager_combat_ended():
	room_cleared = true
	var removable_walls = get_tree().get_nodes_in_group("removable_walls")
	for wall in removable_walls:
		wall.collision.set_deferred("disabled", true)
