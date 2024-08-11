extends State

signal crouched

var coyote_jump : bool
var buffer_jump : bool
var can_hover : bool

@export var character_body : CharacterBody2D
@export var animated_sprite : AnimatedSprite2D

@export_category("Fall Properties")
@export var AIR_SPEED : int = 300
@export var MAX_HORIZONTAL_AIR_SPEED : int = 80
@export var coyote_timer : float = 0.1
@export var jump_buffer_timer : float = 0.1

const GRAVITY = 700

func on_process(delta : float):
	pass
	
func on_physics_process(delta : float):
	# Conditionals for our buffer time and coyote time, first check is for coyote
	if !character_body.is_on_floor():
		# If we press space while in air set buffer jump to true
		if GameInput.jump_input():
			buffer_jump = true
			get_buffer_timer()
		get_coyote_timer()
		character_body.velocity.y += GRAVITY * delta
	
	# Basic movment in air
	var direction = GameInput.movment_input()
	
	if direction:
		character_body.velocity.x += AIR_SPEED * direction
		character_body.velocity.x = clamp(character_body.velocity.x, -MAX_HORIZONTAL_AIR_SPEED, MAX_HORIZONTAL_AIR_SPEED)
	
	if direction != 0:
		animated_sprite.flip_h = false if direction > 0 else true
	
	# Checks Air floor state before move and slide
	var was_on_floor = character_body.is_on_floor()
	character_body.move_and_slide()
	
	# Checks to see if Player was on air before move_and_slide and state after
	var can_buffer_jump : bool = true if !was_on_floor and character_body.is_on_floor() else false
	
	
	# TRANSITION STATES
	
	# If we have hit the hover key only once while in the air and are pressing the hover key
	if GameInput.hover_input() and can_hover and character_body.velocity.y > 0.0:
		can_hover = false
		transition.emit("hover")
	
	# TRANSITION TO BUFFER JUMP STATE
	
	# TRANSITION TO JUMP STATE 
	if buffer_jump and can_buffer_jump:
		transition.emit("jump")
	
	# TRANSITION TO JUMP STATE
	if GameInput.jump_input() and (coyote_jump or (buffer_jump and can_buffer_jump)):
		transition.emit("jump")
	
	# TRANSITION TO IDLE STATE
	if character_body.is_on_floor() and !buffer_jump:
		# Can hover reset when transitioning to idle
		can_hover = true
		transition.emit("idle")
	
	# TRANSITION TO DYING STATE 
	if character_body.is_dying:
		transition.emit("dying")
	
func enter():
	crouched.emit("uncrouched")
	if character_body.previous_state == "hover":
		can_hover = false
	else:
		animated_sprite.play("fall")
	coyote_jump = true
	buffer_jump = false
	
func exit():
	character_body.previous_state = "fall"
	animated_sprite.stop()

# Used to get the timer for our coyote time set to 0.1 seconds
func get_coyote_timer():
	await get_tree().create_timer(coyote_timer).timeout
	coyote_jump = false

# This is for the buffer jump time is set to 0.1 seconds
func get_buffer_timer():
	await get_tree().create_timer(jump_buffer_timer).timeout
	buffer_jump = false	
