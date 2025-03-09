class_name Player extends CharacterBody2D

signal player_status
@export var stats : PlayerStats
@export var tile_map : TileMap

# Used to communicate with the Energy Bar of the players status
@onready var transition_camera := $TransitionCamera
@onready var follow_camera := $FollowCamera
@onready var ray_cast : RayCast2D = $RayCast2D
@onready var animated_sprite := $AnimatedSprite2D
@onready var state_label :=$StatesLabel

var on_wall : bool
var crouched : String
var current_animation : String
var current_frame : int
var extra_jump : bool = false
var can_walljump : bool
var is_dying : bool = false
var is_dying_spikes : bool = false
var previous_state : String

var current_plauyer_health : int
var current_state : String
var player_camera_follow : bool = false

# These signal calls get the crouch state of our Player
func _ready():
	Utils.player_health = 3
	current_plauyer_health = Utils.player_health
	
func _process(_delta):
	# Emits tp Charge Bar so we know how long player is crouching for
	player_status.emit(crouched)
	stats.health = Utils.player_health
	
	var direction = GameInput.movment_input()
	if is_on_floor():
		extra_jump = false
	
	# For Lazer
	if Utils.player_health < current_plauyer_health:
		$AnimationPlayer.play("hit")
		current_plauyer_health = Utils.player_health
	
	if stats.get_health() == 0:
		is_dying_spikes = true
		is_dying = true
	
	var last_label = state_label.text
	state_label.text = current_state
	
	
# For when areas enter Player hitbox
func _on_hit_box_area_entered(area):
	if area.is_in_group("SwitchCamera"):
		transition_camera.enabled = false
		follow_camera.enabled = true
		player_camera_follow = true
	if area.is_in_group("SwitchSnapCamera"):
		transition_camera.enabled = true
		follow_camera.enabled = false
		player_camera_follow = false
	if area.is_in_group("Spikes"):
		is_dying_spikes = true
		is_dying = true
	if area.is_in_group("Lava"):
		is_dying = true
	if area.is_in_group("Bullet"):
		$AnimationPlayer.play("hit")
		is_dying_spikes = true
		is_dying = true
	if area.is_in_group("ExtraJump"):
		extra_jump = true

		
