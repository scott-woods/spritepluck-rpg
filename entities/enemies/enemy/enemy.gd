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

var player : Player
var direction : Vector2
var is_invincible := false
var test

func init(player : Player):
	self.player = player

func _ready():
	stats = stats.copy()
	health_bar.max_value = stats.max_hp
	health_bar.value = stats.hp

func enter_combat_state():
	state_machine.change_state("EnemyCombat/EnemyMoving")

func take_damage(amount):
	SoundPlayer.play_sound(SoundPlayer.ENEMY_HURT)

func die():
	emit_signal("died")


func _on_hurtbox_area_entered(area):
	is_invincible = true


func _on_health_changed(new_value):
	health_bar.value = new_value
