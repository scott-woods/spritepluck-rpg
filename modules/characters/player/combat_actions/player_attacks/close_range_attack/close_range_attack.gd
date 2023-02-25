extends PlayerAttack


#@onready var hitbox : Hitbox = $Hitbox
#@onready var collision_shape : CollisionShape2D = $Hitbox/Collision
@onready var path : Path2D = $MeleePath
@onready var path_follow : PathFollow2D = $MeleePath/MeleePathFollow
@onready var hitbox : Hitbox = $MeleePath/MeleePathFollow/Hitbox
@onready var aim_line : Line2D = $MeleePath/AimLine

@export var dist_from_player : int
@export var attack_time : float

var simulation_player
var direction = Vector2.RIGHT
var origin : Vector2

func _unhandled_input(event):
	super(event)
	if in_setup:
		if event.is_action_pressed("right"):
			direction = Vector2.RIGHT
			position = origin + (direction * dist_from_player)
			path.rotation = direction.angle()
		elif event.is_action_pressed("left"):
			direction = Vector2.LEFT
			position = origin + (direction * dist_from_player)
			path.rotation = direction.angle()
		elif event.is_action_pressed("up"):
			direction = Vector2.UP
			position = origin + (direction * dist_from_player)
			path.rotation = direction.angle()
		elif event.is_action_pressed("down"):
			direction = Vector2.DOWN
			position = origin + (direction * dist_from_player)
			path.rotation = direction.angle()
		elif event.is_action_pressed("accept"):
			aim_line.hide()
			hitbox.hide()
			in_setup = false
			emit_signal("setup_finished", true)

func setup(simulation_player):
	self.simulation_player = simulation_player
	in_setup = true
	origin = position
	#path.reparent(simulation_player, false)
	position = origin + (direction * dist_from_player)
	aim_line.show()
	hitbox.show()
	
func execute():
	hitbox.collision.set_deferred("disabled", false)
	while hitbox.collision.disabled:
		await get_tree().process_frame
	hitbox.show()
	var tween = create_tween()
	tween.tween_property(path_follow, "progress_ratio", 1, attack_time)
	await tween.finished
	hitbox.collision.disabled = true
	hitbox.hide()
