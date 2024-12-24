extends State

@export var character_body : CharacterBody2D
@export var animated_sprite : AnimatedSprite2D
	
func enter():
	animated_sprite.play("idle")
	
func exit():
	character_body.previous_state = "Textbox"
	animated_sprite.stop()
