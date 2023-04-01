extends Node2D


@onready var enemy_spawner : EnemySpawner = $EnemySpawner
@onready var combat_manager : CombatManager = $CombatManager
@onready var player_spawner : PlayerSpawner = $PlayerSpawner
@onready var map : TileMap = $Map

func _ready():
	player_spawner.spawn_player()
	
	Game.player.utility_dropped.connect(_on_player_utility_dropped)
	
	combat_manager.combat_ended.connect(_on_combat_manager_combat_ended)
	combat_manager.action_created.connect(_on_combat_manager_action_created)
	combat_manager.simulation_player_created.connect(_on_combat_manager_simulation_player_created)
	
	Game.camera.set_target(Game.player)
	
	start()

func start():
	if SceneManager.transitioning:
		await SceneManager.scene_change_finished

	combat_manager.start_combat()


func _on_player_utility_dropped(utility : Utility):
	map.add_child(utility)

func _on_combat_manager_combat_ended():
	RoomsManager.increment_rooms_cleared(self)
	var removable_walls = get_tree().get_nodes_in_group("removable_walls")
	for wall in removable_walls:
		wall.collision.set_deferred("disabled", true)

func _on_combat_manager_action_created(action):
	map.add_child(action)

func _on_combat_manager_simulation_player_created(simulation_player):
	map.add_child(simulation_player)
