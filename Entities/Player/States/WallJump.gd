extends State

var timer : SceneTreeTimer
var wall_normal : Vector2

@export var character_body : CharacterBody2D
@export var animated_sprite : AnimatedSprite2D
@export var tile_data : TileDataDetection

@export_category("WallJump Properties")
@export var SPEED : int = 20
@export var MAX_HORIZONTAL_SPEED = 100
@export var walljump_timer : float = 4	
@export var can_cling : bool 

const GRAVITY = 10
const LOSS_GRIP_GRAVITY = 5
const NO_GRIP_GRAVITY = 7

func on_physics_process(_delta : float):	
	# Basic horizontal ground movment
	if timer.time_left != 0 and tile_data.tile_type == "walljump":
		character_body.velocity.y = GRAVITY
	elif timer.time_left != 0 and tile_data.tile_type == "wall":
		character_body.velocity.y += NO_GRIP_GRAVITY
	else:
		character_body.velocity.y += LOSS_GRIP_GRAVITY
	
	if GameInput.jump_input():
		if character_body.get_wall_normal().x == 1:
			character_body.velocity.x = 100 
		if character_body.get_wall_normal().x == -1:
			character_body.velocity.x = -100 
	
	
	character_body.move_and_slide()
	
	# TRANSITION STATES
	# TRANSITION TO IDLE STATE
	if !GameInput.grab_input() or character_body.on_wall == false:
		transition.emit("fall")
		
	
		
	# TRANSITION TO FALL STATE
	if GameInput.jump_input():
		transition.emit("jump")
		
	
func enter():
	print("walljump")
	can_cling = true
	timer = get_tree().create_timer(3)
	animated_sprite.play("cling")
	
func exit():
	tile_data.tile_type = ""
	character_body.previous_state = "walljump"
	animated_sprite.stop()
	
