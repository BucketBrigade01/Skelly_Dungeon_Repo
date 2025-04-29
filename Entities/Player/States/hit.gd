extends State

signal disable_hitbox

@export var player : Player
@export var animated_sprite : AnimatedSprite2D
@export var knockback_force : float = 100.0  # Force to push player back
@export var knockback_time : float = 0.2  # Time for knockback effect
@export var recovery_time : float = 0.2  # Time before returning to idle
@export var hit_box : CollisionShape2D

const GRAVITY = 700
var hit : bool = false
var knockback_direction : float
var current_time : float = 0.0

func on_physics_process(delta) -> void:
	player.velocity.y += GRAVITY * delta
	
	# Handle knockback effect
	if current_time < knockback_time:
		# Apply knockback force
		player.velocity.x = knockback_direction * knockback_force
		
	else:
		# Slow down after initial knockback
		player.velocity.x = move_toward(player.velocity.x, 0, delta * 500)
	# Move player
	player.move_and_slide()
	
	# Update timer
	current_time += delta
	
	# Transition to idle after recovery time
	if current_time >= knockback_time + recovery_time:
		transition.emit("idle")
	
	if player.is_dying:
		transition.emit("dying")
	
func enter():
	animated_sprite.play("idle")
	player.current_state = "hit"
	knockback_direction = sign(((player.global_position - player.attack_position).normalized()).x)
	print_debug(((player.global_position - player.attack_position).normalized()))
	# Reset timer
	current_time = 0.0
	player.velocity.y = -knockback_force
	emit_signal("disable_hitbox")
	
func exit():
	player.previous_state = "hit"
	animated_sprite.stop()
	player.hit = false
	player.velocity = Vector2.ZERO

func get_hit_timer() -> void:
	await get_tree().create_timer(0.3).timeout
	transition.emit("idle")
