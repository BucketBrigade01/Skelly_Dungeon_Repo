extends Area2D
class_name DetectionBox

func _on_body_entered(body):
	if body is Player:
		if owner.has_method("activate"):
			owner.activate()
