extends Node2D


@onready var enemy = $TileMap/FastEnemy
@onready var player = $TileMap/Player

func _ready():
	enemy.init(player)
	enemy.enter_combat_state()
