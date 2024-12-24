extends StaticBody2D
class_name Coin



func _on_collection_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Utils.coin_count += 1
		$AnimatedSprite2D.play("collected")



func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
