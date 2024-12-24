extends State
class_name BirdIdle

@export var bird : LazerBird
@export var animation_sprite : AnimatedSprite2D

var difference : Vector2

func on_process(_delta : float):
	difference = bird.target.global_position - bird.position
	if difference.length() < 70:
		transition.emit("hatch")
	
func enter():
	animation_sprite.play("idle")
	
func exit():
	pass
