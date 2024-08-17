extends State

signal crouched

@export var character_body : CharacterBody2D
@export var animated_sprite : AnimatedSprite2D

@export_category("Idle Properties")
@export var FRICTION : int = 10

func on_process(delta : float):
	pass
	
func on_physics_process(delta : float):
	pass
	
func enter():
	animated_sprite.play("idle_hatched")
	
func exit():
	animated_sprite.stop()

func _on_detection_box_body_entered(body):
	if body.is_in_group("Player"):
		transition.emit("flying")
