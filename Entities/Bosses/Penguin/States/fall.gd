extends State

@export var penguin : Penguin
@export var animation : AnimatedSprite2D

const GRAVITY = 700
	
func on_physics_process(delta : float):
	# Conditionals for our buffer time and coyote time, first check is for coyote
	if !penguin.is_on_floor():
		penguin.velocity.y += GRAVITY * delta

	penguin.move_and_slide()
	
	# TRANSITION STATES
	
	# TRANSITION TO IDLE STATE
	if penguin.is_on_floor():
		transition.emit("idle")
	
	if penguin.dying == true:
		transition.emit("die")
	
func enter():
	penguin.current_state = "fall"
	animation.play("fall")
	
func exit():
	penguin.previous_state = "fall"
	animation.stop()
