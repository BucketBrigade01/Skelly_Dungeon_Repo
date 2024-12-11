extends State
class_name SquishBirdCharge

@export var animated_sprite : AnimatedSprite2D

func on_physics_process(delta : float) -> void:
	pass

func on_process(delta : float) -> void:
	pass

func enter():
	animated_sprite.play("charge")

func exit():
	animated_sprite.stop()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "charge":
		transition.emit("fall")
