extends AttackAction


@export var LineSelector : PackedScene

@onready var hitbox = $Hitbox

@export var dash_time : float
@export var radius : int
var points

func _ready():
	label = "Dash Attack"
	type = "ATTACK"

func setup(simulation_player):
	in_setup = true
	var line_selector = LineSelector.instantiate()
	line_selector.init(player.last_direction, simulation_player.global_position, simulation_player, radius)
	add_child(line_selector)
	points = await line_selector.line_selected
	line_selector.queue_free()
	in_setup = false
	emit_signal("setup_finished", true)
	
func execute():
	hitbox.collision.disabled = false
	hitbox.reparent(player, false)
	await get_tree().process_frame
	hitbox.show()
	var target_pos = points[1]
	var tween = create_tween()
	var color = player.sprite.modulate
	player.sprite.modulate = Color.from_hsv(0, 0, 100, .5)
	SoundPlayer.play_sound(SoundPlayer.DASH_ATTACK)
	tween.tween_property(player, "global_position", target_pos, dash_time)
	await tween.finished
	player.sprite.modulate = color
	hitbox.collision.disabled = true
	hitbox.queue_free()
