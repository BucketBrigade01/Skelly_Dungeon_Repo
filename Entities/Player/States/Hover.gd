extends State

var can_hover : bool

@export var character_body : CharacterBody2D
@export var animated_sprite : AnimatedSprite2D

@export_category("Hover Properties")
@export var HOVER_SPEED : int = 20
@export var MAX_HORIZONTAL_HOVER_SPEED = 150
@export var HOVER_GRAVITY : int = 1000
@export var FRICTION : int = 5
@export var hover_timer : float = 0.5


func on_process(delta : float):
	pass
	
func on_physics_process(delta : float):
	# Slows down upward velocity
	if character_body.velocity.y < 0.0:
		character_body.velocity.y = move_toward(character_body.velocity.y, 0, 20)
	else:
		if GameInput.hover_input(): 
			character_body.velocity.y = HOVER_GRAVITY * delta
	
	# Basic Air movment
	var direction = GameInput.movment_input()
	
	if direction:
		character_body.velocity.x += HOVER_SPEED * direction
		character_body.velocity.x = clamp(character_body.velocity.x, -MAX_HORIZONTAL_HOVER_SPEED, MAX_HORIZONTAL_HOVER_SPEED)
	else:
		character_body.velocity.x = move_toward(character_body.velocity.x, 0, FRICTION)
	
	if direction != 0:
		animated_sprite.flip_h = false if direction > 0 else true
		
	character_body.move_and_slide()
	
	# TRANSITION STATES
	
	# TRANSITION TO FALL STATE
	
	if !GameInput.hover_input() or !can_hover:
		transition.emit("fall")
	
	# TRANSITION TO IDLE STATE
	
	if character_body.is_on_floor():
		transition.emit("idle")
		
func enter():
	can_hover = true
	animated_sprite.play("hover")
	get_hover_timer()
	
func exit():
	character_body.previous_state = "hover"
	animated_sprite.stop()

# Sets hover to false after 0.5 second timer
func get_hover_timer():
	await get_tree().create_timer(hover_timer).timeout
	can_hover = false

