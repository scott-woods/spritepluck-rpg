class_name Enemy
extends CharacterBody2D


signal health_changed(new_value)
signal died
signal player_spotted

@onready var collision : CollisionShape2D = $Collision
@onready var sprite : Sprite2D = $Sprite
@onready var hurtbox : Hurtbox = $Hurtbox
@onready var state_machine : StateMachine = $StateMachine
@onready var actions : Array = $Actions.get_children()
@onready var health_bar : ProgressBar = $HealthBar
@onready var navigation_agent : NavigationAgent2D = $NavigationAgent

@export var stats : CharacterStats
@export var can_move := true

var player : Player
var direction : Vector2

func init(player : Player):
	self.player = player

func _ready():
	stats = stats.copy()
	health_bar.max_value = stats.max_hp
	health_bar.value = stats.hp
	setup_navigation()
	
func setup_navigation():
	await get_tree().physics_frame
	navigation_agent.max_speed = stats.speed
	navigation_agent.radius = max(sprite.get_rect().size.x, sprite.get_rect().size.y) / 2
	navigation_agent.target_position = position

func enter_combat_state():
	if can_move:
		state_machine.change_state("EnemyCombat/EnemyMoving")
	else:
		state_machine.change_state("EnemyCombat")

func take_damage(amount):
	SoundPlayer.play_sound(SoundPlayer.ENEMY_HURT)
	stats.hp -= amount
	if stats.hp <= 0:
		stats.hp = 0
	emit_signal("health_changed", stats.hp)
	if stats.hp == 0:
		die()
	else:
		hurtbox.collision.disabled = true
		await get_tree().create_timer(stats.invincible_time).timeout
		hurtbox.collision.disabled = false

func die():
	emit_signal("died")
	queue_free()


func _on_hurtbox_area_entered(area):
	take_damage(area.damage)


func _on_health_changed(new_value):
	health_bar.value = new_value