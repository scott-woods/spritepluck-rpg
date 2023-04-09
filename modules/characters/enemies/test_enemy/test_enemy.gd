class_name TestEnemy
extends Enemy


const ACTION_COOLDOWN : float = 1

@onready var sprite : Sprite2D = $Sprite
@onready var collision : CollisionShape2D = $Collision
@onready var hurtbox : Hurtbox = $Hurtbox
@onready var state_machine : StateMachine = $StateMachine

#actions
@onready var radial_shot : RadialShot = $Actions/RadialShot

var player : Player

func _ready():
	player = Game.player

func enter_combat_state():
	state_machine.change_state("TestEnemyCombat")
