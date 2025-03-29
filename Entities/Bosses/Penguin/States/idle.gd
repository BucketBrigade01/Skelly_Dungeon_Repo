extends State

@export var penguin : Penguin
@export var animation : AnimatedSprite2D

@export_category("Idle Properties")
@export var FRICTION : int = 40

var can_move : bool = true

func on_physics_process(_delta : float):
	# Slows player down using FRICTION
	penguin.velocity.x = move_toward(penguin.velocity.x, 0, FRICTION)
	
	var difference = penguin.global_position.distance_to(penguin.target.position)
	var direction = penguin.global_position.direction_to(penguin.target.position)
	
	penguin.move_and_slide()
	
	# TRANSITION STATES
	
	# TRANSITION TO FALL STATE
	if !penguin.is_on_floor():
		transition.emit("fall")
		
	if difference < 125 and difference > 50 and penguin.is_on_floor() and can_move:
		transition.emit("walk")
	
	if difference < 50 and penguin.can_punch:
		if direction.x < 0:
			animation.flip_h = false
		elif direction.x > 0:
			animation.flip_h = true
		transition.emit("punch")
	
func enter():
	animation.play("idle")
	can_move = false
	get_idle_timer()
	get_punch_timer()
	penguin.current_state = "idle"
	
func exit():
	penguin.previous_state = "idle"
	animation.stop()

func get_idle_timer() -> void:
	await get_tree().create_timer(0.5).timeout
	can_move = true
	
func get_punch_timer() -> void:
	await get_tree().create_timer(0.5).timeout
	penguin.can_punch = true
