class_name StateMachine
extends Node


@export var initial_state := NodePath()

@onready var current_state: State = get_node(initial_state)
@onready var states : Array = get_children()

var previous_state : State

func _ready():
	#wait until parent is ready
	await owner.ready
	
	#init states
	for state in states:
		state.init(self)
		
	#call begin on initial state
	current_state.begin()

func _unhandled_input(event):
	current_state.handle_input(event)

func _process(delta):
	current_state.update(delta)

func _physics_process(delta):
	current_state.physics_update(delta)

func change_state(target_state_name, params := {}):
	current_state.end()
	previous_state = current_state
	current_state = get_node(target_state_name)
	current_state.begin(params)
