class_name Ranger
extends Enemy


const ACTION_COOLDOWN : float = 1.5

@onready var sprite : Sprite2D = $Sprite
@onready var hurtbox : Hurtbox = $Hurtbox
@onready var collision : CollisionShape2D = $Collision
@onready var velocity_component : VelocityComponent = $VelocityComponent
@onready var pathfinding_component : PathfindingComponent = $PathfindingComponent
@onready var state_machine : StateMachine = $StateMachine

#Actions
@onready var snipe : Snipe = $Actions/Snipe

var player : Player

func _ready():
	player = Game.player

func enter_combat_state():
	state_machine.change_state("RangerCombat")
