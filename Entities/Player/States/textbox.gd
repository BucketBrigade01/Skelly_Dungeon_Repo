extends State

@export var player : Player
@export var animated_sprite : AnimatedSprite2D

const GRAVITY = 700

func enter():
	animated_sprite.play("idle")
	player.current_state = "textbox"

func exit():
	player.previous_state = "textbox"
	animated_sprite.stop()
