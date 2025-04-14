extends State

@export var animation : AnimatedSprite2D

@onready var death_sound := $"../../DeathSound"

func enter():
	death_sound.play()
	animation.play("die")
	
func exit():
	pass
