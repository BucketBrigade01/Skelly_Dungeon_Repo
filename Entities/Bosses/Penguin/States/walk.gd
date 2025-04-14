extends State

@export var penguin : Penguin
@export var animation : AnimatedSprite2D

@export_category("Walk Properties")
@export var SPEED := 2500
@export var TURNING_DELAY := 2.0

@onready var belly_collider : CollisionShape2D = $"../../BellyZone/CollisionShape2D"
@onready var hit_collider : CollisionShape2D = $"../../HitZone/CollisionShape2D"
@onready var damage_collider : CollisionShape2D = $"../../DamageZone/CollisionShape2D"

#var direction : int
var can_move : bool = true
var is_turning : bool = false
var turning_timer : float = 0.0
var previous_direction : Vector2 = Vector2.ZERO

func on_physics_process(delta : float):
	# Slows player down using FRICTION
	var difference = penguin.global_position.distance_to(penguin.target.position)
	var direction = penguin.global_position.direction_to(penguin.target.position)
	
	if previous_direction != Vector2.ZERO and sign(previous_direction.x) != sign(direction.x):
		if !is_turning:
			$"../../Label".visible = true
			is_turning = true
			turning_timer = 0.0
			can_move = false
			penguin.can_punch = false
			animation.play("idle")
	
	# Handle turning timer
	if is_turning:
		turning_timer += delta
		if turning_timer >= TURNING_DELAY:
			is_turning = false
			can_move = true
			animation.play("walk")
			
	else:
		# Only update direction immediately if not turning
		$"../../Label".visible = false
		penguin.can_punch = true
		animation.flip_h = (direction.x > 0)
		belly_collider.position.x = 16.25 if direction.x > 0 else -16.25
		hit_collider.position.x = -17.0 if direction.x > 0 else 17.0
		damage_collider.position.x = 34.0 if direction.x > 0 else -34.0
	
	# Store current direction for next frame comparison
	previous_direction = direction
	
	if can_move:
		penguin.velocity.x = SPEED * direction.x * delta
	
	penguin.move_and_slide()
	
	# TRANSITION STATES
	
	# TRANSITION TO FALL STATE
	if !penguin.is_on_floor():
		transition.emit("fall")
	
	# TRANSITION TO IDLE STATE
	if difference < 40:
		transition.emit("idle")
	
	if penguin.can_icefall:
		transition.emit("icefall")
	
	if penguin.dying == true:
		transition.emit("die")
func enter():
	penguin.can_punch = true
	can_move = true
	animation.play("walk")
	penguin.current_state = "walk"
	
func exit():
	$"../../Label".visible = false
	penguin.previous_state = "walk"
	is_turning = false
	turning_timer = 0.0
	animation.stop()

func get_idle_timer() -> void:
	await get_tree().create_timer(1).timeout
	can_move = true
