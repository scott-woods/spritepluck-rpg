class_name InheritedRoom
extends Room


@onready var combat_manager : CombatManager = $CombatManager
@onready var combat_ui : CombatUI = $CombatUI
@onready var default_ui : DefaultUI = $DefaultUI
@onready var default_spawn_point : PlayerSpawnPoint = $Map/SpawnPointContainer/DefaultSpawnPoint

func _ready():
	super()
	
func start():
	var spawn_position = default_spawn_point.position
	if SceneManager.current_spawn_point:
		for spawn in spawn_point_container.get_children():
			if spawn.spawn_id == SceneManager.current_spawn_point:
				spawn_position = spawn.position
				break
	spawn_player(spawn_position)
	
	camera.set_target(player)
	
	#combat manager setup
	combat_manager.setup(player, combat_ui, camera, map)
	combat_manager.combat_ended.connect(_on_combat_manager_combat_ended)
	
	#combat ui setup
	combat_ui.setup(player, combat_manager)


func _on_combat_manager_combat_ended():
	pass
