extends State
class_name SquishBirdSquish

@export var animated_sprite : AnimatedSprite2D

func enter():
	animated_sprite.play("squish")

func exit():
	animated_sprite.stop()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "squish":
		transition.emit("reset")
