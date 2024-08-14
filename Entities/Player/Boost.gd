extends State

signal crouched

@export_category("Jump Properties")
@export var JUMP_HEIGHT : float = 56
@export var WEAK_JUMP_HEIGHT : float = 48
@export var SUPER_WEAK_JUMP_HEIGHT : float = 40
@export var JUMP_TIME_PEAK : float = 0.35
@export var JUMP_TIME_DESCENT : float = 0.28

@export_category("Horizontal Properties")
@export var JUMP_HORIZONTAL_SPEED : float
@export var MAX_HORIZONTAL_JUMP_SPEED : float
@export var FRICTION : int = 10

@export var character_body : CharacterBody2D
@export var animated_sprite : AnimatedSprite2D

var JUMP_VELOCITY : float = ((2.0 * JUMP_HEIGHT) / JUMP_TIME_PEAK) * -1
var WEAK_JUMP_VELOCITY : float = ((2.0 * WEAK_JUMP_HEIGHT) / JUMP_TIME_PEAK) * -1
var SUPER_WEAK_JUMP_VELOCITY : float = ((2.0 * SUPER_WEAK_JUMP_HEIGHT) / JUMP_TIME_PEAK) * -1
var JUMP_GRAVITY : float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_PEAK * JUMP_TIME_PEAK)) * -1
var FALL_GRAVITY : float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_DESCENT * JUMP_TIME_DESCENT)) * -1

func on_process(delta : float):
	pass
	
func on_physics_process(delta : float):
	# Slows down players initial horizontal velocity
	character_body.velocity.x = move_toward(character_body.velocity.x, 0, FRICTION)
	character_body.velocity.y += get_gravity() * delta
	
	# This is the maximum boost jump, activated when energy bar is full
	if character_body.is_on_floor() and Utils.player_animation == "full" and GameInput.jump_input():
		character_body.velocity.y = JUMP_VELOCITY
		transition.emit("fall")
	
	# This is the min boost jump, activated whenever bar is not full
	if (character_body.is_on_floor() and (Utils.player_animation == "charge" and Utils.player_animation_frame > 8) or (Utils.player_animation == "decharge" and Utils.player_animation_frame < 8)) and GameInput.jump_input():
		character_body.velocity.y = WEAK_JUMP_VELOCITY
		transition.emit("fall")
	
	# This is for the super weak jump when the bar is hardly full	
	if (character_body.is_on_floor() and (Utils.player_animation == "charge" and Utils.player_animation_frame < 8) or (Utils.player_animation == "decharge" and Utils.player_animation_frame > 8)) and GameInput.jump_input():
		character_body.velocity.y = SUPER_WEAK_JUMP_VELOCITY
		transition.emit("fall")
		
	character_body.move_and_slide()
	# TRANSITION STATES
	
	# TRANSITION TO IDLE STATE
	if !GameInput.boost_input():
		transition.emit("idle")
	
	# TRANSITION TO DYING STATE 
	if character_body.is_dying:
		transition.emit("dying")
		
func enter():
	# Emited so Player knows crouch state
	crouched.emit("crouched")
	animated_sprite.play("charge")
	
func exit():
	character_body.previous_state = "boost"
	animated_sprite.stop()

func get_gravity() -> float:
	if character_body.velocity.y > 0.0:
		return FALL_GRAVITY
	return JUMP_GRAVITY
