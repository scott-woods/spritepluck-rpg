extends Room


const MIN_ENEMIES : int = 4
const MAX_ENEMIES : int = 6

@export var Player : PackedScene
@export var enemy_types : Array[PackedScene]

@onready var enemy_spawn_points = $Map/EnemySpawnPoints
@onready var combat_manager : CombatManager = $CombatManager
@onready var combat_ui : CombatUI = $CombatUI

var enemies : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	#instantiate player
	player = Player.instantiate() as Player
	var spawn_position = default_spawn_point.position
	if SceneManager.current_spawn_point:
		for spawn in spawn_point_container.get_children():
			if spawn.spawn_id == SceneManager.current_spawn_point:
				spawn_position = spawn.position
				break
	player.position = spawn_position
	map.add_child(player)

	camera.set_target(player)
	
	#combat manager setup
	combat_manager.setup(player, combat_ui, camera, map)
	combat_manager.combat_ended.connect(_on_combat_manager_combat_ended)
	
	#combat ui setup
	combat_ui.setup(player, combat_manager)
	
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
	combat_ui.show()
	combat_manager.start_combat()


func _on_combat_manager_combat_ended():
	combat_ui.hide()
