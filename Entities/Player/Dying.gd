extends State

signal crouched

@export var character_body : CharacterBody2D
@export var animated_sprite : AnimatedSprite2D
@export var timer : float = 1.0

const GRAVITY = 700

func on_process(delta : float):
	pass
	
func on_physics_process(delta : float):
	pass
	
func enter():
	if character_body.is_dying_spikes:
		animated_sprite.play("spike_death")
	else:
		animated_sprite.play("lava_death")
	crouched.emit("uncrouched")
	get_reset_timer()
	
func exit():
	character_body.previous_state = "dying"
	animated_sprite.stop()

func get_reset_timer():
	await get_tree().create_timer(timer).timeout
	get_tree().reload_current_scene()

