extends State
class_name SquishBirdFall

@export var animated_sprite : AnimatedSprite2D
@export var squish_bird : SquishBird

func on_physics_process(delta : float) -> void:
	squish_bird.velocity.y += 50 
	squish_bird.move_and_slide()
	if squish_bird.is_on_floor():
		transition.emit("squish")

func on_process(delta : float) -> void:
	pass

func enter():
	animated_sprite.play("fall")

func exit():
	animated_sprite.stop()
