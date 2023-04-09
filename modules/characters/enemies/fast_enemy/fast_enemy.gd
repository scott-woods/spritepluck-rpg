class_name FastEnemy
extends Enemy


const ACTION_COOLDOWN = 1

@onready var sprite : Sprite2D = $Sprite
@onready var hurtbox : Hurtbox = $Hurtbox
@onready var collision : CollisionShape2D = $Collision
@onready var state_machine : StateMachine = $StateMachine
@onready var velocity_component : VelocityComponent = $VelocityComponent
@onready var pathfinding_component : PathfindingComponent = $PathfindingComponent
@onready var melee_swipe : MeleeSwipe = $Actions/MeleeSwipe

var player : Player

func _ready():
	player = Game.player

func enter_combat_state():
	state_machine.change_state("FastEnemyCombat")
