extends State
class_name SquishBirdIdle

@export var animated_sprite : AnimatedSprite2D

var timer : SceneTreeTimer

func on_process(_delta : float) -> void:
	if timer.time_left == 0:
		transition.emit("charge")

func enter():
	animated_sprite.play("idle")
	timer = get_tree().create_timer(3)
	
func exit():
	animated_sprite.stop()
