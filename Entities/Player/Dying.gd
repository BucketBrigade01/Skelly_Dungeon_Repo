extends State

@export var character_body : Player
@export var animated_sprite : AnimatedSprite2D
@export var timer : float = 1.0

const GRAVITY = 700

func enter():
	if character_body.is_dying_spikes:
		animated_sprite.play("spike_death")
	else:
		animated_sprite.play("lava_death")
	get_reset_timer()
	character_body.current_state = "dying"
	
func exit():
	character_body.previous_state = "dying"
	animated_sprite.stop()

func get_reset_timer():
	await get_tree().create_timer(timer).timeout
	get_tree().reload_current_scene()
