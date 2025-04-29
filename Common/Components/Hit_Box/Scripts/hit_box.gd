extends Area2D
class_name HitBox

@onready var collider : CollisionShape2D = $CollisionShape2D

func disable_collision() -> void:
	collider.set_deferred("disabled", true)

func enable_collision() -> void:
	collider.set_deferred("disabled", false)

func _on_area_entered(area):
	pass

func _on_area_exited(area):
	pass # Replace with function body.


func _on_body_entered(body):
	pass # Replace with function body.


func _on_body_exited(body):
	pass # Replace with function body.
