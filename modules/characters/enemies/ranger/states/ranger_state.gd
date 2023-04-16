class_name RangerState
extends State


var ranger : Ranger

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	ranger = owner as Ranger
