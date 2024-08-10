class_name StateMachine extends Node

@export var initial_state : State

var states : Dictionary = {}
var current_state : State
var current_state_name : String

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition.connect(transition_to)
			
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.on_process(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.on_physics_process(delta)

func transition_to(state_name: String) -> void:
	if current_state_name == state_name:
		return
		
	var new_state = states.get(state_name.to_lower())
	
	if !new_state:
		return
		
	if current_state:
		current_state.exit()
	
	new_state.enter()
	
	current_state = new_state
	current_state_name = current_state.name.to_lower()


