extends Area2D
class_name HurtBox

@onready var collider : CollisionShape2D = $CollisionShape2D

func disable_collision() -> void:
	collider.set_deferred("disabled", true)

func enable_collision() -> void:
	collider.set_deferred("disabled", false)

func _on_area_entered(area):
	if area.is_in_group("Bullet"):
		var direction = sign(owner.global_position.direction_to(area.global_position).x)
		if owner.has_method("set_direction"):
			owner.set_direction(direction)
		if owner.has_method("take_damage"):
			owner.take_damage()
		if owner.is_in_group("Enemy"):
			$BirdHurt.play()
		if owner.has_method("set_knockback"):
			owner.set_knockback(true)
		if owner.has_method("break_object"):
			print_debug("break Rockl")
			owner.break_object()
			
func _on_area_exited(area):
	pass # Replace with function body.


func _on_body_entered(body):
	pass # Replace with function body.


func _on_body_exited(body):
	pass # Replace with function body.
