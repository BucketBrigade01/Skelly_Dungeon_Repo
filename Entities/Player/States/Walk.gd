extends State

signal crouched

@export var character_body : CharacterBody2D
@export var animated_sprite : AnimatedSprite2D

@export_category("WallJump Properties")
@export var SPEED : int = 20
@export var MAX_HORIZONTAL_SPEED = 100

const GRAVITY = 700

func on_process(delta : float):
	pass
	
func on_physics_process(delta : float):
	# Basic horizontal ground movment
	var direction = GameInput.movment_input()
	
	if direction:
		character_body.velocity.x += SPEED * direction
		character_body.velocity.x = clamp(character_body.velocity.x, -MAX_HORIZONTAL_SPEED, MAX_HORIZONTAL_SPEED)
	
	if direction != 0:
		animated_sprite.flip_h = false if direction > 0 else true
		
	character_body.move_and_slide()
	
	# TRANSITION STATES
	
	# TRANSITION TO IDLE STATE
	if direction == 0:
		transition.emit("idle")
		
	# TRANSITION TO FALL STATE
	if !character_body.is_on_floor():
		transition.emit("fall")
		
	# TRANSITION TO JUMP STATE
	if GameInput.jump_input():
		transition.emit("jump")
		
	# TRANSITION TO DYING STATE 
	if character_body.is_dying:
		transition.emit("dying")
	
	# TRANSITION TO SHOOT STATE
	if GameInput.shoot_input():
		transition.emit("Shoot")
	
func enter():
	crouched.emit("uncrouched")
	animated_sprite.play("walk")
	
func exit():
	character_body.previous_state = "walk"
	animated_sprite.stop()
