extends State

signal crouched

@export var character_body : CharacterBody2D
@export var animated_sprite : AnimatedSprite2D

func on_process(delta : float):
	pass
	
func on_physics_process(delta : float):
	pass
	
func enter():
	animated_sprite.play("idle")
	
	
func exit():
	animated_sprite.stop()

func _on_detection_box_area_entered(area):
	if area.is_in_group("Player"):
		transition.emit("hatching")
