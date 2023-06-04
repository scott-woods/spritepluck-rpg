extends Room


@onready var combat_manager : CombatManager = $CombatManager
@onready var player_spawner : PlayerSpawner = $PlayerSpawner
@onready var dungeon_room_component : DungeonRoomComponent = $DungeonRoomComponent

var room_data : DungeonRoomData = DungeonRoomData.new()

func init(data : DungeonRoomData):
	if data:
		room_data = data

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

	if room_data.room_cleared == false:
		combat_manager.start_combat()
