extends State

@export var tile_data : TileDataDetection
@export var character_body : Player
@export var animated_sprite : AnimatedSprite2D
@export var land_target : Marker2D
@export var boost_particle : GPUParticles2D

@export_category("Fall Properties")
@export var AIR_SPEED : int = 350
@export var MAX_HORIZONTAL_AIR_SPEED : int = 80
@export var coyote_timer : float = 0.1
@export var jump_buffer_timer : float = 0.2

@onready var fall_particle : PackedScene = preload("res://Entities/Particles/Land_Particle/jump_particle.tscn")

var coyote_jump : bool
var buffer_jump : bool
var can_hover : bool
var can_wall_jump := false

const GRAVITY = 700
	
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
	
	# If we have hit the hover key only once while in the air and are pressing the hover key
	if GameInput.hover_input() and can_hover and character_body.velocity.y > 0.0 and Utils.player_power_ups['hover'] == true:
		can_hover = false
		transition.emit("hover")
	
	if character_body.velocity.y > -20 and character_body.previous_state == "boost":
		boost_particle.emitting = false
	
	# TRANSITION STATES
	
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
		var fall_particle_inst = fall_particle.instantiate()
		if fall_particle_inst:
			fall_particle_inst.global_position = land_target.global_position
			character_body.get_parent().add_child(fall_particle_inst)
		transition.emit("idle")
		
	# TRANSITION TO DYING STATE 
	if character_body.is_dying:
		transition.emit("dying")
	
	# TRANSITION TO WALLJUMP STATE
	if can_wall_jump and GameInput.grab_input() and tile_data.tile_type == "walljump" and Utils.player_power_ups['wall_jump'] == true:
		can_hover = true
		if character_body.previous_state == "boost" and character_body.velocity > Vector2.ZERO:
			transition.emit("walljump")
		elif character_body.previous_state == "hover":
			transition.emit("walljump")
	
	if character_body.can_climb and Input.get_axis("up", "down") != 0:
		transition.emit("climb")
	
func enter():
	coyote_jump = true
	buffer_jump = false
	character_body.current_state = "fall"
	if character_body.previous_state == "hover":
		can_hover = false
		coyote_jump = false
		can_wall_jump = true
		animated_sprite.play("fall")
	elif character_body.previous_state == "boost":
		can_hover = true
		coyote_jump = false
		can_wall_jump = true
		animated_sprite.play("fall")
		boost_particle.emitting = true
	else:
		animated_sprite.play("fall")
	
func exit():
	character_body.previous_state = "fall"
	animated_sprite.stop()
	boost_particle.emitting = false
# Used to get the timer for our coyote time set to 0.1 seconds
func get_coyote_timer():
	await get_tree().create_timer(coyote_timer).timeout
	coyote_jump = false

# This is for the buffer jump time is set to 0.1 seconds
func get_buffer_timer():
	await get_tree().create_timer(jump_buffer_timer).timeout
	buffer_jump = false	
