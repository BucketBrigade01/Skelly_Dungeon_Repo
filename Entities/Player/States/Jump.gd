extends State

signal crouched

@export var character_body : CharacterBody2D
@export var animated_sprite : AnimatedSprite2D

@export_category("Jump Properties")
@export var JUMP_HEIGHT : float = 32
@export var JUMP_TIME_PEAK : float = 0.35
@export var JUMP_TIME_DESCENT : float = 0.28
@export var MIN_JUMP_HEIGHT : float = 16
@export var MIN_JUMP_TIME : float = 0.18
@export var jump_buffer_timer : float = 0.1

@export_category("Horizontal Properties")
@export var JUMP_HORIZONTAL_SPEED : float
@export var MAX_HORIZONTAL_JUMP_SPEED : float

var JUMP_VELOCITY : float = ((2.0 * JUMP_HEIGHT) / JUMP_TIME_PEAK) * -1
var JUMP_GRAVITY : float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_PEAK * JUMP_TIME_PEAK)) * -1
var FALL_GRAVITY : float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_DESCENT * JUMP_TIME_DESCENT)) * -1
var EARLY_RELEASE_GRAVITY = (MIN_JUMP_HEIGHT - JUMP_VELOCITY * MIN_JUMP_TIME) / (MIN_JUMP_TIME * MIN_JUMP_TIME)

var coyote_jump : bool
var buffer_jump : bool 

func on_process(delta : float):
	pass
	
func on_physics_process(delta : float):
	# REDULAR JUMP / COYOTE JUMP + GRAVITY
	character_body.velocity.y += get_gravity() * delta
	
	if character_body.is_on_floor() or coyote_jump or character_body.extra_jump == true:
		character_body.velocity.y = JUMP_VELOCITY
		coyote_jump = false
		character_body.extra_jump = false
	else:
		if GameInput.jump_input():	
			if !buffer_jump:
				buffer_jump = true
				get_buffer_timer()
	# AIR MOVMENT
	
	var direction : float = GameInput.movment_input()
	if direction:
		character_body.velocity.x += JUMP_HORIZONTAL_SPEED * direction
		character_body.velocity.x = clamp(character_body.velocity.x, -MAX_HORIZONTAL_JUMP_SPEED, MAX_HORIZONTAL_JUMP_SPEED)
	
	# FLIP SPRITE
	
	if direction != 0:
		animated_sprite.flip_h = false if direction > 0 else true
	
	var was_on_floor = character_body.is_on_floor()
	
	character_body.move_and_slide()
	
	# BUFFER JUMP
	
	if !was_on_floor and character_body.is_on_floor():
		if buffer_jump:
			character_body.velocity.y = JUMP_VELOCITY
	
	# TRANSITION STATES
	
	# TRANSITION TO HOVER STATE
	if GameInput.hover_input() and character_body.velocity.y > 0.0:
		transition.emit("hover")
	
	# TRANSITION TO IDLE STATE
	if character_body.is_on_floor():
		transition.emit("idle")
	
	# TRANSITION TO WALLJUMP STATE
	if GameInput.grab_input() and character_body.is_on_wall() and character_body.velocity.y > 0.0 and character_body.can_walljump:
		transition.emit("walljump")
	
	# TRANSITION TO DYING STATE 
	if character_body.is_dying:
		transition.emit("dying")
	
	# TRANSITION TO SHOOT STATE
	if GameInput.shoot_input():
		transition.emit("Shoot")
	
func enter():
	crouched.emit("uncrouched")
	coyote_jump = true
	buffer_jump = false
	animated_sprite.play("jump")
	
func exit():
	character_body.previous_state = "jump"
	coyote_jump = false
	animated_sprite.stop()

func get_gravity() -> float:
	if character_body.velocity.y > 0.0:
		return FALL_GRAVITY
	if GameInput.jump_pressed_input():
		return JUMP_GRAVITY
		
	return EARLY_RELEASE_GRAVITY

# Buffer jump timer set to 0.1 seconds	
func get_buffer_timer():
	await get_tree().create_timer(jump_buffer_timer).timeout
	buffer_jump = false	
