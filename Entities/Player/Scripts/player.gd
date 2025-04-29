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
var hit : bool = false
var attack_position : Vector2
var can_climb : bool = false
var on_falling_platform : bool = false
var ladder_tween : Tween
var hit_timer : SceneTreeTimer

# These signal calls get the crouch state of our Player
func _ready():
	current_player_health = Utils.player_health
	current_shooting_state = ShootState.NOTSHOOTING
	$StateMachine/Hit.connect("disable_hitbox", disable_hitbox)
	if Utils.player_spawnpoint == 0:
		self.position = spawn_start.position
	elif Utils.player_spawnpoint == 2:
		self.position = spawn_mid.position
	elif Utils.player_spawnpoint == 4:
		self.position = spawn_final.position

func _process(_delta):
	# Emits tp Charge Bar so we know how long player is crouching for
	player_status.emit(crouched)
	projectile_spawner.position.x = -3 if animated_sprite.flip_h else 3
	
	if is_on_floor():
		extra_jump = false
	
	if Input.is_action_just_pressed("shoot") and Utils.player_power_ups['basic_shoot'] == true:
		change_state(ShootState.SHOOTING)
	else:
		change_state(ShootState.NOTSHOOTING)
	
	if $LadderDetection4.is_colliding() or $LadderDetection5.is_colliding():
		var collider = $LadderDetection4.get_collider()
		var collider2 = $LadderDetection5.get_collider()
		can_climb = true
		
		if collider and collider.is_in_group("Ladder") and current_state != "fall":
			ladder_tween = get_tree().create_tween()
			ladder_tween.tween_property(self, "global_position:x", collider.global_position.x, 0.1)
		elif collider2 and collider2.is_in_group("Ladder") and current_state != "fall":
			ladder_tween = get_tree().create_tween()
			ladder_tween.tween_property(self, "global_position:x", collider2.global_position.x, 0.1)
		
	else:
		can_climb = false
		if ladder_tween and ladder_tween.is_running():
			ladder_tween.kill()
	# For Lazer
	if Utils.player_health < current_player_health:
		#$AnimationPlayer.play("hit")
		current_player_health = Utils.player_health
		$HurtSound.play()

	if Utils.get_health() == 0:
		is_dying_spikes = true
		is_dying = true
	
	if hit_timer and hit_timer.time_left > 0.0:
		var speed_scale_modifier : float = clamp(3.0 / hit_timer.time_left, 1.0, 5.0) 
		$AnimationPlayer.speed_scale = speed_scale_modifier
	
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

func disable_hitbox() -> void:
	print_debug("disable hitbox")
	$HitBox/CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("Alpha")
	get_hitbox_timer() 

func get_hitbox_timer() -> void:
	hit_timer = get_tree().create_timer(1.5)
	await hit_timer.timeout
	$HitBox/CollisionShape2D.set_deferred("disabled", false)
	$AnimationPlayer.play("RESET")
	print_debug("enable hitbox")
# For when areas enter Player hitbox
func _on_hit_box_area_entered(area):
	if area.is_in_group("SwitchCamera"):
		#new_camera.change_state(new_camera.CameraStates.FOLLOW)
		pass
	if area.is_in_group("SwitchSnapCamera"):
		#new_camera.change_state(new_camera.CameraStates.SNAP)
		pass
	if area.is_in_group("Spikes"):
		is_dying_spikes = true
		is_dying = true
	if area.is_in_group("FallingPlatform"):
		on_falling_platform = true
	if area.is_in_group("Lava"):
		is_dying = true
	if area.is_in_group("Key"):
		var key_instance = key.instantiate()
		key_instance.position = area.position
		get_parent().add_child(key_instance)
	if area.is_in_group("SmallBullet") or area.is_in_group("IceBullet"):
		#$AnimationPlayer.play("hit")
		stats.health -= 1
		Utils.set_health(-1)
		attack_position = area.global_position
		hit = true
	if area.is_in_group("ExtraJump"):
		extra_jump = true
	if area.is_in_group("PenguinDamage"):
		#$AnimationPlayer.play("hit")
		stats.health -= 1
		Utils.set_health(-1)
		attack_position = area.global_position
		hit = true
	if area.is_in_group("Readable"):
		player_can_read = true
	if area.is_in_group("UpDownBird"):
		#$AnimationPlayer.play("hit")
		stats.health -= 1
		Utils.set_health(-1)
		attack_position = area.global_position
		hit = true
	if area.is_in_group("AutoBullet"):
		#$AnimationPlayer.play("hit")
		stats.health -= 1
		Utils.set_health(-1)
		attack_position = area.global_position
		hit = true
	if area.is_in_group("Explode"):
		#$AnimationPlayer.play("hit")
		stats.health -= 1
		Utils.set_health(-1)
		attack_position = area.global_position
		hit = true

func _on_hit_box_area_exited(area: Area2D) -> void:
	if area.is_in_group("Readable"):
		player_can_read = false
	if area.is_in_group("FallingPlatform"):
		on_falling_platform = false
