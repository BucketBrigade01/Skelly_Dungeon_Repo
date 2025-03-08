extends State

@export var character_body : Player
@export var animated_sprite : AnimatedSprite2D

@export_category("Idle Properties")
@export var FRICTION : int = 10
	
func on_physics_process(_delta : float):
	# Slows player down using FRICTION
	character_body.velocity.x = move_toward(character_body.velocity.x, 0, FRICTION)
	character_body.move_and_slide()
	
	# TRANSITION STATES
	
	# TRANSITION TO FALL STATE
	var direction : float = GameInput.movment_input()
	
	if !character_body.is_on_floor():
		transition.emit("fall")
	
	# TRANSITION TO WALK STATE
	if direction != 0:
		transition.emit("walk")
		
	# TRANSITION TO JUMP STATE
	if GameInput.jump_input():
		transition.emit("jump")
		
	# TRANSITION TO BOOST STATE
	if GameInput.boost_input():
		transition.emit("boost")
	
	# TRANSITION TO DYING STATE 
	if character_body.is_dying:
		transition.emit("dying")
	
	# TRANSITION TO SHOOT STATE
	if GameInput.shoot_input():
		transition.emit("Shoot")
	
func enter():
	animated_sprite.play("idle")
	character_body.current_state = "idle"
	
func exit():
	character_body.previous_state = "idle"
	animated_sprite.stop()
	
