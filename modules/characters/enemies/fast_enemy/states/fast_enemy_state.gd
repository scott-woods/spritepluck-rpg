class_name FastEnemyState
extends State


var fast_enemy : FastEnemy

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	fast_enemy = owner as FastEnemy
