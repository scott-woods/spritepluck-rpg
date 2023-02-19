extends Node2D


@onready var player : Player = $TileMap/Player
@onready var enemies : Node = $TileMap/Enemies
@onready var test_enemy : TestEnemy = $TileMap/Enemies/TestEnemy
@onready var combat_ui = $UI/CombatUI
@onready var tilemap = $TileMap
@onready var utilities = $TileMap/Utilities
@onready var camera = $Camera
@onready var combat_manager : CombatManager = $CombatManager

# Called when the node enters the scene tree for the first time.
func _ready():
	combat_manager.init(player, enemies, utilities, combat_ui, camera, tilemap)
	player.init(utilities, combat_ui, camera)
	camera.target = player
	combat_ui.init(player)
	for enemy in enemies.get_children():
		enemy.init(player)
