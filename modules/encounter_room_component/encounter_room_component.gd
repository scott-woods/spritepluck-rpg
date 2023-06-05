class_name EncounterRoomComponent
extends Node


@export var player_spawner : PlayerSpawner
@export var combat_manager : CombatManager

var room_data : DungeonRoomData

func _ready():
	await owner.ready
	room_data = owner.room_data
	start()
	
func start():
	player_spawner.spawn_player()
	Game.camera.set_target(Game.player)

	if SceneManager.transitioning:
		await SceneManager.scene_change_finished
	
	if room_data.room_cleared == false:
		combat_manager.start_combat()
