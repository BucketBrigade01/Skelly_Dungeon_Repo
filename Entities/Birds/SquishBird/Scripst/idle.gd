extends State
class_name SquishBirdIdle

@export var animated_sprite : AnimatedSprite2D

var timer : SceneTreeTimer

func on_physics_process(delta : float) -> void:
	pass

func on_process(delta : float) -> void:
	if timer.time_left == 0:
		transition.emit("charge")

func enter():
	print("idle")
	animated_sprite.play("idle")
	timer = get_tree().create_timer(4)
	
func exit():
	animated_sprite.stop()
