extends State
class_name SquishBirdReset

@export var animated_sprite : AnimatedSprite2D
@export var squish_bird : SquishBird

func on_physics_process(delta : float) -> void:
	squish_bird.velocity.y = -30 
	if squish_bird.is_on_ceiling():
		animated_sprite.play("tilt")
		
	squish_bird.move_and_slide()

func on_process(delta : float) -> void:
	pass

func enter():
	animated_sprite.play("reset")

func exit():
	pass
