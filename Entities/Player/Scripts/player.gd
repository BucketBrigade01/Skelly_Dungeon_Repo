class_name Player extends CharacterBody2D

signal player_status

@export var tile_map : TileMap

# Used to communicate with the Energy Bar of the players status
@onready var transition_camera = $TransitionCamera
@onready var follow_camera = $FollowCamera
@onready var ray_cast = $RayCast2D
@onready var animated_sprite = $AnimatedSprite2D


var on_wall : bool
var crouched : String
var current_animation : String
var current_frame : int
var extra_jump : bool = false
var can_walljump : bool
var is_dying : bool 
var is_dying_spikes : bool
var previous_state : String

# These signal calls get the crouch state of our Player
func _ready():
	$StateMachine/Boost.crouched.connect(_is_crouched)
	$StateMachine/Idle.crouched.connect(_is_crouched)
	$StateMachine/Walk.crouched.connect(_is_crouched)
	$StateMachine/Fall.crouched.connect(_is_crouched)
	$StateMachine/Jump.crouched.connect(_is_crouched)
	
func _process(delta):
	# Emits tp Charge Bar so we know how long player is crouching for
	player_status.emit(crouched)
	
	# Get mocment direction so we can change raycast position
	var direction = GameInput.movment_input()

	if direction != 0:
		ray_cast.rotation_degrees = 90 * -direction
	
	# Wall Jump check using tileData
	if is_near_wall():
		# Check if raycast is colliding
		var collider = ray_cast.get_collider()
		if collider is TileMap:
			# If tileMap then we can check our raycast collision point
			# As well as the normal due to weird glitch with the raycast point and
			# Local to map not acounting for 0 index on tilemap cell
			var position : Vector2 = ray_cast.get_collision_point() 
			var normal : Vector2 = ray_cast.get_collision_normal()
			var local_position = tile_map.local_to_map(position)
			# We subtract from the x of our local position to account for 0 index
			if normal.x == 1:
				local_position.x -= 1
			if tile_map.get_cell_tile_data(1, local_position) is TileData:
				var data = tile_map.get_cell_tile_data(0, local_position)
				can_walljump = true
			else:
				can_walljump = false
	else: 
		can_walljump = false
# Check if raycast is colliding
func is_near_wall():
	return ray_cast.is_colliding() 
	
# Used to communicate with States on weather they are a crouch or uncrouched state
func _is_crouched(message : String):
	if message == "crouched":
		crouched = message
	if message == "uncrouched":
		crouched = message

# Extra jump detection for hitbox for bodys entered
func _on_hit_box_body_entered(body):
	if body.is_in_group("ExtraJump"):
		extra_jump = true

# For when areas enter Player hitbox
func _on_hit_box_area_entered(area):
	if area.is_in_group("SwitchCamera"):
		transition_camera.enabled = false
		follow_camera.enabled = true
	if area.is_in_group("Spikes"):
		is_dying_spikes = true
		is_dying = true
	if area.is_in_group("Lava"):
		is_dying = true

# Used for the Energy bar to communicate with Player of animation state
func _on_charge_bar_energy_animation(frame, animation):
	Utils.player_animation_frame = int(frame)
	Utils.player_animation = animation
