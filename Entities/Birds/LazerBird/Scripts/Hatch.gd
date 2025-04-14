extends State
class_name BirdHatch

@export var bird : LazerBird
@export var animation_sprite : AnimatedSprite2D
@export var bird_sprite : Sprite2D

var difference : Vector2
var animation_complete : bool 

func on_process(_delta : float):
	if animation_complete:
		transition.emit("idlehatched")
	
func enter():
	animation_sprite.play("hatching")
	bird_sprite.visible = true
	animation_complete = false
	
func exit():
	bird_sprite.visible = false

func _on_animated_sprite_2d_animation_finished():
	animation_complete = true
