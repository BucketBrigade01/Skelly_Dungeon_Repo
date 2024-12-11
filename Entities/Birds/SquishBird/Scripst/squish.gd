extends State
class_name SquishBirdSquish

@export var animated_sprite : AnimatedSprite2D

func on_physics_process(delta : float) -> void:
	pass

func on_process(delta : float) -> void:
	pass

func enter():
	animated_sprite.play("squish")

func exit():
	animated_sprite.stop()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "squish":
		transition.emit("reset")
