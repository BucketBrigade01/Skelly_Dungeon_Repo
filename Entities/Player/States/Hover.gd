extends State

var can_hover : bool

@export var character_body : Player
@export var animated_sprite : AnimatedSprite2D
@export var tile_data : TileDataDetection
@export var particle : GPUParticles2D
@export var hover_target : Marker2D
@export var small_hover_particle : Node2D

@export_category("Hover Properties")
@export var HOVER_SPEED : int = 20
@export var MAX_HORIZONTAL_HOVER_SPEED = 150
@export var HOVER_GRAVITY : int = 1000
@export var FRICTION : int = 5
@export var hover_timer : float = 0.5

@onready var hover_particle : PackedScene = preload("res://Entities/Particles/Hover_Particles/hover_particle.tscn")

var timer : SceneTreeTimer
	
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
	
	particle.scale.x = -1 if direction < 0 else 1
		
	character_body.move_and_slide()
	
	# TRANSITION STATES
	
	# TRANSITION TO FALL STATE
	if GameInput.jump_input() and character_body.extra_jump:
		transition.emit("jump")
	
	if !GameInput.hover_input() or !can_hover:
		transition.emit("fall")
	
	# TRANSITION TO WALLJUMP STATE
	if GameInput.grab_input() and tile_data.tile_type == "walljump":
		can_hover = true
		transition.emit("walljump")
	
	# TRANSITION TO IDLE STATE
	
	if character_body.is_on_floor():
		transition.emit("idle")
	
	if character_body.can_climb and Input.get_axis("up", "down") != 0:
		transition.emit("climb")
	
func enter():
	particle.emitting = true
	can_hover = true
	animated_sprite.play("hover")
	get_hover_timer()
	character_body.current_state = "hover"
	var hover_particle_inst = hover_particle.instantiate()
	if hover_particle_inst:
		hover_particle_inst.global_position = hover_target.global_position
		character_body.get_parent().add_child(hover_particle_inst)
	small_hover_particle.emmit(true)
	
func exit():
	particle.emitting = false
	character_body.previous_state = "hover"
	small_hover_particle.emmit(false)
	animated_sprite.stop()
	timer.set_time_left(0.0)
# Sets hover to false after 0.5 second timer
func get_hover_timer():
	timer = get_tree().create_timer(hover_timer)
	await timer.timeout
	can_hover = false
