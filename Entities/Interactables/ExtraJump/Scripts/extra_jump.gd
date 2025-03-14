extends StaticBody2D


@export var regrow := AnimationPlayer


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite2D.play("end")
		$BreakSound.play()
		get_regrow_timer()

func get_regrow_timer() -> void:
	await get_tree().create_timer(1).timeout
	$CollisionShape2D.set_deferred("disabled", false)
	$AnimatedSprite2D/AnimationPlayer.play("regrow")
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$AnimatedSprite2D.play("idle")
