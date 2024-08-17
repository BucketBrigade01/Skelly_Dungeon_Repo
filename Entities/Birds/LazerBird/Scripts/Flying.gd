extends State

signal crouched

@export var character_body : CharacterBody2D
@export var animated_sprite : AnimatedSprite2D

func on_process(delta : float):
	pass
	
func on_physics_process(delta : float):
	var position_difference = character_body.target.global_position - character_body.global_position
	print(position_difference)
	
func enter():
	animated_sprite.play("flying")
	
func exit():
	animated_sprite.stop()
	

