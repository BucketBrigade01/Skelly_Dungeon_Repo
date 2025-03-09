extends State

@export_category("Jump Properties")
@export var JUMP_HEIGHT : float = 56
@export var WEAK_JUMP_HEIGHT : float = 48
@export var SUPER_WEAK_JUMP_HEIGHT : float = 40
@export var JUMP_TIME_PEAK : float = 0.35
@export var JUMP_TIME_DESCENT : float = 0.28

@export_category("Horizontal Properties")
@export var JUMP_HORIZONTAL_SPEED : float
@export var MAX_HORIZONTAL_JUMP_SPEED : float
@export var FRICTION : int = 10

@export var character_body : Player
@export var animated_sprite : AnimatedSprite2D

var JUMP_VELOCITY : float = ((2.0 * JUMP_HEIGHT) / JUMP_TIME_PEAK) * -1
var WEAK_JUMP_VELOCITY : float = ((2.0 * WEAK_JUMP_HEIGHT) / JUMP_TIME_PEAK) * -1
var SUPER_WEAK_JUMP_VELOCITY : float = ((2.0 * SUPER_WEAK_JUMP_HEIGHT) / JUMP_TIME_PEAK) * -1
var JUMP_GRAVITY : float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_PEAK * JUMP_TIME_PEAK)) * -1
var FALL_GRAVITY : float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_DESCENT * JUMP_TIME_DESCENT)) * -1
var timer : SceneTreeTimer

func on_physics_process(delta : float):
	# Slows down players initial horizontal velocity
	character_body.velocity.x = move_toward(character_body.velocity.x, 0, FRICTION)
	character_body.velocity.y += get_gravity() * delta
	
	if timer.time_left == 0:
		Utils.player_crouch_val += 1
		timer = get_tree().create_timer(0.02)

	
	if Utils.player_crouch_val >= 20 and character_body.is_on_floor() and GameInput.jump_input():
		character_body.velocity.y = JUMP_VELOCITY
		transition.emit("fall")
		
	if Utils.player_crouch_val >= 10 and Utils.player_crouch_val < 20 and character_body.is_on_floor() and GameInput.jump_input():
		character_body.velocity.y = WEAK_JUMP_VELOCITY
		transition.emit("fall")
	
	if Utils.player_crouch_val < 10 and character_body.is_on_floor() and GameInput.jump_input():
		character_body.velocity.y = SUPER_WEAK_JUMP_VELOCITY
		transition.emit("fall")
		
	character_body.move_and_slide()
	# TRANSITION STATES
	
	# TRANSITION TO IDLE STATE
	if !GameInput.boost_input():
		transition.emit("idle")
	
	# TRANSITION TO DYING STATE 
	if character_body.is_dying:
		transition.emit("dying")
func enter():
	# Emited so Player knows crouch state
	timer = get_tree().create_timer(0.2)
	Utils.player_crouched = true
	animated_sprite.play("charge")
	character_body.current_state = "boost"
	
func exit():
	character_body.previous_state = "boost"
	Utils.player_crouched = false
	animated_sprite.stop()

func get_gravity() -> float:
	if character_body.velocity.y > 0.0:
		return FALL_GRAVITY
	return JUMP_GRAVITY
