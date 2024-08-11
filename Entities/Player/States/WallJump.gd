extends State

signal crouched

var timer : Timer = Timer.new()
var wall_normal : Vector2

@export var character_body : CharacterBody2D
@export var animated_sprite : AnimatedSprite2D

@export_category("WallJump Properties")
@export var SPEED : int = 20
@export var MAX_HORIZONTAL_SPEED = 100
@export var walljump_timer : float = 4	
@export var can_cling : bool 

const GRAVITY = 10
const LOSS_GRIP_GRAVITY = 5

func on_process(delta : float):
	pass
	
func on_physics_process(delta : float):	
	# Basic horizontal ground movment
	if timer.time_left != 0:
		character_body.velocity.y = GRAVITY
	else:
		character_body.velocity.y += LOSS_GRIP_GRAVITY
	
	var direction = GameInput.movment_input()
	
	if GameInput.jump_input():
		if character_body.get_wall_normal().x == 1:
			character_body.velocity.x = 50 
		if character_body.get_wall_normal().x == -1:
			character_body.velocity.x = -50 
	
	
	character_body.move_and_slide()
	
	# TRANSITION STATES
	
	# TRANSITION TO IDLE STATE
	if !GameInput.grab_input() or !character_body.is_near_wall():
		transition.emit("fall")
		
	
		
	# TRANSITION TO FALL STATE
	if GameInput.jump_input():
		transition.emit("jump")
		
	
func enter():
	can_cling = true
	add_child(timer)
	timer.autostart = false
	timer.one_shot = true
	timer.wait_time = 3
	timer.start()
	crouched.emit("uncrouched")
	animated_sprite.play("cling")
	
func exit():
	timer.stop()
	animated_sprite.stop()
	

