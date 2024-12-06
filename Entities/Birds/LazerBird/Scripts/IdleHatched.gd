extends State
class_name BirdIdleHatched

@export var bird : LazerBird
@export var animation_sprite : AnimatedSprite2D

var difference : Vector2
var animation_complete : bool 

func on_process(delta : float):
	difference = bird.target.global_position - bird.position
	if difference.length() < 60:
		transition.emit("flying")
	
func enter():
	animation_sprite.play("idle_hatched")
	
func exit():
	animation_sprite.stop()
