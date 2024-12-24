extends State
class_name SquishBirdReset

@export var animated_sprite : AnimatedSprite2D
@export var squish_bird : SquishBird

var player : CharacterBody2D

func on_physics_process(_delta : float) -> void:
	squish_bird.velocity.y = -30 
	squish_bird.move_and_slide()
	if squish_bird.get_slide_collision_count() > 0:
		if squish_bird.is_on_ceiling_only() and squish_bird.get_slide_collision(0).get_collider().get_class() == "StaticBody2D":
			transition.emit("tilt")
func enter():
	animated_sprite.play("reset")

func exit():
	pass
