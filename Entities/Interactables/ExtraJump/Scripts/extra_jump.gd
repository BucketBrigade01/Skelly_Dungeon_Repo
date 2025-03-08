extends StaticBody2D





func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$AnimatedSprite2D.play("end")



func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
