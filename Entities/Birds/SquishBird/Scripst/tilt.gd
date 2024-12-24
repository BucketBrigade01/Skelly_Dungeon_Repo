extends State
class_name SquishBirdTilt

@export var animated_sprite : AnimatedSprite2D
@export var squish_bird : SquishBird

func enter():
	animated_sprite.play("tilt")

func exit():
	pass

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "tilt":
		transition.emit("idle")
