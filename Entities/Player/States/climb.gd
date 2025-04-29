extends State

@export var player : Player
@export var animated_sprite : AnimatedSprite2D
@export var SPEED = 1000

func on_physics_process(delta : float) -> void:
	var direction = Input.get_axis("down", "up")
	
	if direction != 0.0:
		animated_sprite.play("climb")
		player.velocity.y = -SPEED * delta * direction
	else:
		animated_sprite.pause()
		player.velocity.y = 0.0
	
	player.move_and_slide()
	
	if GameInput.jump_input() and direction == 0:
		transition.emit("fall")
	if !player.can_climb:
		transition.emit("fall")
		
func enter():
	animated_sprite.play("climb")
	player.current_state = "climb"

func exit():
	player.previous_state = "climb"
	animated_sprite.stop()
	player.can_climb = false
	player.ladder_tween.kill()
