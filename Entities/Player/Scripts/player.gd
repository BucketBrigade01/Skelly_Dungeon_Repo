class_name Player extends CharacterBody2D

signal player_status

@export var stats : PlayerStats
@export var tile_map : TileMap
@export var spawn_start : Marker2D
@export var spawn_mid : Marker2D 
@export var spawn_final : Marker2D

# Used to communicate with the Energy Bar of the players status
@onready var transition_camera := $TransitionCamera
@onready var follow_camera := $FollowCamera
@onready var ray_cast : RayCast2D = $RayCast2D
@onready var animated_sprite := $AnimatedSprite2D
@onready var new_camera : CombinedCamera = get_parent().get_node("Camera")

# Shooting variables
@onready var projectile_spawner := $ProjectileSpawner
@onready var projectile_noise := $ShootSound

# Packed Scenes
@onready var key : PackedScene = preload("res://Entities/Collectables/FollowKey/follow_key.tscn")
@onready var bullet = preload("res://Entities/Damagables/Projectiles/simple_projectile.tscn")

enum ShootState {
	SHOOTING, 
	NOTSHOOTING
}

# Walljump Variables
var on_wall : bool
var can_walljump : bool

# Crouched Variables
var crouched : String

# Animation Variables
var current_animation : String
var current_frame : int
var extra_jump : bool = false
var valid_state : Array[String] = ["walljump", "boost"]

# Death Variables
var is_dying : bool = false
var is_dying_spikes : bool = false

# State Variables
var previous_state : String
var current_state : String
var current_shooting_state : ShootState
var current_player_health : int
var player_camera_follow : bool = false
var player_can_read : bool = false
var player_is_reading : bool = false

# These signal calls get the crouch state of our Player
func _ready():
	current_player_health = Utils.player_health
	current_shooting_state = ShootState.NOTSHOOTING
	if Utils.player_spawnpoint == 0:
		self.position = spawn_start.position
	elif Utils.player_spawnpoint == 2:
		self.position = spawn_mid.position
	elif Utils.player_spawnpoint == 4:
		self.position = spawn_final.position

func _process(_delta):
	# Emits tp Charge Bar so we know how long player is crouching for
	player_status.emit(crouched)
	projectile_spawner.position.x = -2 if animated_sprite.flip_h else 2
	
	if is_on_floor():
		extra_jump = false
	
	if Input.is_action_just_pressed("shoot"):
		change_state(ShootState.SHOOTING)
	else:
		change_state(ShootState.NOTSHOOTING)
	
	# For Lazer
	if Utils.player_health < current_player_health:
		$AnimationPlayer.play("hit")
		current_player_health = Utils.player_health
		$HurtSound.play()

	if Utils.get_health() == 0:
		is_dying_spikes = true
		is_dying = true

func change_state(new_state : ShootState) -> void:
	current_shooting_state = new_state
	match current_shooting_state:
		ShootState.SHOOTING:
			if !valid_state.has(current_state):
				var bullet_instance = bullet.instantiate()
				get_parent().add_child(bullet_instance)
				bullet_instance.global_position = projectile_spawner.global_position
				if animated_sprite.flip_h:
					bullet_instance.flip_projectile()
				projectile_noise.play()
		ShootState.NOTSHOOTING:
			pass
			
# For when areas enter Player hitbox
func _on_hit_box_area_entered(area):
	if area.is_in_group("SwitchCamera"):
		new_camera.change_state(new_camera.CameraStates.FOLLOW)
	if area.is_in_group("SwitchSnapCamera"):
		new_camera.change_state(new_camera.CameraStates.SNAP)
	if area.is_in_group("Spikes"):
		is_dying_spikes = true
		is_dying = true
	if area.is_in_group("Lava"):
		is_dying = true
	if area.is_in_group("Key"):
		var key_instance = key.instantiate()
		key_instance.position = area.position
		get_parent().add_child(key_instance)
	if area.is_in_group("SmallBullet"):
		$AnimationPlayer.play("hit")
		stats.health -= 1
		Utils.set_health(-1)
	if area.is_in_group("ExtraJump"):
		extra_jump = true
	if area.is_in_group("PenguinDamage"):
		$AnimationPlayer.play("hit")
		stats.health -= 1
		Utils.set_health(-1)
	if area.is_in_group("Readable"):
		player_can_read = true

func _on_hit_box_area_exited(area: Area2D) -> void:
	if area.is_in_group("Readable"):
		player_can_read = false
