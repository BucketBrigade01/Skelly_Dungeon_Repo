extends State

@export var penguin : Penguin
@export var animation : AnimatedSprite2D

@export_category("Walk Properties")
@export var SPEED := 2500
	
var direction : int
var can_move : bool = true

func on_physics_process(delta : float):
	# Slows player down using FRICTION
	var difference = penguin.global_position.distance_to(penguin.target.position)
	var direction = penguin.global_position.direction_to(penguin.target.position)
	
	animation.flip_h = (direction.x > 0)
	
	if can_move:
		penguin.velocity.x = SPEED * direction.x * delta
	
	penguin.move_and_slide()
	
	# TRANSITION STATES
	
	# TRANSITION TO FALL STATE
	if !penguin.is_on_floor():
		transition.emit("fall")
	
	# TRANSITION TO IDLE STATE
	if difference < 40:
		transition.emit("idle")
	
	if penguin.can_icefall:
		transition.emit("icefall")
	
func enter():
	penguin.can_punch = true
	animation.play("walk")
	penguin.current_state = "walk"
	
func exit():
	penguin.previous_state = "walk"
	animation.stop()

func get_idle_timer() -> void:
	await get_tree().create_timer(1).timeout
	can_move = true
