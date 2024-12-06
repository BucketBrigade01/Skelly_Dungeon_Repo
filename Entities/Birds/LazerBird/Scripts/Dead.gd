extends State
class_name BirdDead


@export var bird : LazerBird
@export var animation_sprite : AnimatedSprite2D

func on_process(delta : float):
	pass
	
func enter():
	bird.dead = true
	
func exit():
	animation_sprite.stop()

