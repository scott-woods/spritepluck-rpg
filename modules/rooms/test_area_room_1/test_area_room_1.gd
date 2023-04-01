extends Room


const MIN_ENEMIES : int = 1
const MAX_ENEMIES : int = 1

@export var Player : PackedScene
@export var enemy_types : Array[PackedScene]

@onready var enemy_spawn_points = $Map/EnemySpawnPoints
@onready var combat_manager : CombatManager = $CombatManager
@onready var exit_collision : StaticBody2D = $Map/ExitCollision
@onready var exit : Area2D = $Map/Exit

var enemies : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	player = Game.player
	player.utility_dropped.connect(_on_player_utility_dropped)
	
	camera = Game.camera
	super()

func start():
	spawn_player()
	camera.set_target(player, true)
	
	if SceneManager.transitioning:
		await SceneManager.scene_change_finished
	spawn_enemies()
	start_combat()

func spawn_enemies():
	var enemy_num = randi_range(MIN_ENEMIES, MAX_ENEMIES)
	var spawns = enemy_spawn_points.get_children().duplicate()
	while enemies.size() < enemy_num:
		var enemy_type = enemy_types[randi_range(0, enemy_types.size() - 1)]
		var enemy = enemy_type.instantiate()
		enemy.init(player)
		var spawn = spawns[randi_range(0, spawns.size() - 1)]
		enemy.position = spawn.position
		map.add_child(enemy)
		enemies.append(enemy)
		spawns.erase(spawn)

func start_combat():
	combat_manager.start_combat(enemies)


func _on_player_utility_dropped(utility : Utility):
	map.add_child(utility)

func _on_combat_manager_combat_ended():
	RoomsManager.increment_rooms_cleared(self)
	exit_collision.get_node("CollisionShape2D").set_deferred("disabled", true)

func _on_combat_manager_action_created(action):
	map.add_child(action)

func _on_combat_manager_simulation_player_created(simulation_player):
	map.add_child(simulation_player)

func _on_exit_body_entered(body):
	exit.get_node("CollisionShape2D").set_deferred("disabled", true)
	RoomsManager.get_next_room("right")
