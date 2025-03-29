extends Area2D
class_name Coin

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		$CollisionShape2D.set_deferred("disabled", true)
		Utils.set_coint_count(1)
		$AnimatedSprite2D.play("collected")
		$AudioStreamPlayer2D.play()
