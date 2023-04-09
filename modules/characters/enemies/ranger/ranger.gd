class_name Ranger
extends Enemy


const ACTION_COOLDOWN : float = 1.5
const INVINCIBILITY_TIME : float = 1

@onready var sprite : Sprite2D = $Sprite
@onready var hurtbox : Hurtbox = $Hurtbox
@onready var collision : CollisionShape2D = $Collision
@onready var velocity_component : VelocityComponent = $VelocityComponent
@onready var pathfinding_component : PathfindingComponent = $PathfindingComponent
@onready var state_machine : StateMachine = $StateMachine
@onready var health_component : HealthComponent = $HealthComponent

#Actions
@onready var snipe : Snipe = $Actions/Snipe

var player : Player

func _ready():
	player = Game.player

func enter_combat_state():
	state_machine.change_state("RangerCombat")


func _on_hurtbox_hit(hitbox):
	hurtbox.disable()
	health_component.damage(hitbox.damage)
	if health_component.hp > 0:
		await get_tree().create_timer(INVINCIBILITY_TIME).timeout
		hurtbox.enable()


func _on_health_component_hp_depleted():
	SoundPlayer.play_sound(SoundPlayer.ENEMY_HURT)
	emit_signal("died")
	queue_free()
