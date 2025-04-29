extends State
class_name BirdFlying

@export var bird : LazerBird
@export var animation_sprite : AnimatedSprite2D
@export var speed : int = 10
@export var ray_cast : RayCast2D
@export var lazer : LazerBeam
@export var upward_speed : int
@export var acceleration : float = 10.0  # For snappier movement
@export var min_distance : float = 3.0  # Minimum distance to keep from player
@export var ideal_distance : float = 20.0 
@export var hover_height : float = 10.0  # How high to hover above player
@export var sine_amplitude : float = 20.0  # Size of side-to-side movement
@export var sine_frequency : float = 2.0  # Speed of side-to-side movement

var knock_back_strength := 150
var sine_time : float = 0.0

func on_physics_process(delta : float):
	
	if !bird.on_screen:
		return
	
	sine_time += delta
	
	if bird.knock_back_direction:
		# Apply knockback and mark as being knocked back
		var current_direction = 1 if !animation_sprite.flip_h else -1
		bird.velocity = Vector2(-current_direction, -0.2) * knock_back_strength
		bird.knock_back_direction = 0
		
		# Apply the velocity while in knockback
		bird.move_and_slide()
		return
	
	var target_pos = bird.target.global_position
	var direction = target_pos - bird.global_position
	var distance = direction.length()
	
	var target_velocity = Vector2.ZERO
	if distance < min_distance:
		# Too close - back away quickly
		target_velocity = -direction.normalized() * speed * 0.05
		
	elif distance < ideal_distance :
		var hover_position = Vector2(
			target_pos.x + sin(sine_time * sine_frequency) * sine_amplitude,
			target_pos.y - hover_height
		)
		
		var to_hover = hover_position - bird.global_position
		# In the sweet spot - strafe around player
		target_velocity = to_hover * speed * 0.05
	elif distance < 100:
		# Close but not ideal - approach cautiously
		target_velocity = direction.normalized() * speed * 0.7
	else:
		# Too far - approach quickly
		target_velocity = direction.normalized() * speed * 1.2
	
	# Apply acceleration for snappier movement
	bird.velocity = bird.velocity.lerp(target_velocity, acceleration * delta)
	
	# Handle animations and visuals
	animation_sprite.flip_h = direction.x < 0
	
	# Handle laser activation
	if distance < ideal_distance + 30 and bird.stats.get_health() != 0:
		lazer.enabled = true
	else:
		lazer.enabled = false
	
	# Check for collision with environment
	#if ray_cast.is_colliding():
		#bird.velocity = Vector2.ZERO
		#transition.emit("idlehatched")

	
	bird.move_and_slide()
	
func enter():
	animation_sprite.play("flying")
	
func exit():
	animation_sprite.stop()
