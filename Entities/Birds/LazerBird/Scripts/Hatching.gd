extends State

signal crouched

@export var character_body : CharacterBody2D
@export var animated_sprite : AnimatedSprite2D

var finished_hatching : bool 

func on_process(delta : float):
	if finished_hatching:
		transition.emit("idlehatch")
	
func on_physics_process(delta : float):
	pass
	
func enter():
	finished_hatching = false
	animated_sprite.play("hatching")
	
func exit():
	animated_sprite.stop()
	
func _on_animated_sprite_2d_animation_finished():
	finished_hatching = true
