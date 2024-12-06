extends State
class_name BirdHatch

@export var bird : LazerBird
@export var animation_sprite : AnimatedSprite2D

var difference : Vector2
var animation_complete : bool 

func on_process(delta : float):
	if animation_complete:
		transition.emit("idlehatched")
	
func enter():
	animation_sprite.play("hatching")
	animation_complete = false
	
func exit():
	pass

func _on_animated_sprite_2d_animation_finished():
	animation_complete = true
