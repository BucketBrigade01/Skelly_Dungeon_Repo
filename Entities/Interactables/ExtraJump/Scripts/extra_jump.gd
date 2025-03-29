class_name ExtraJump extends Area2D


@export var regrow := AnimationPlayer

func get_regrow_timer() -> void:
	await get_tree().create_timer(1).timeout
	$CollisionShape2D.set_deferred("disabled", false)
	$AnimatedSprite2D/AnimationPlayer.play("regrow")
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$AnimatedSprite2D.play("idle")


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite2D.play("end")
		$BreakSound.play()
		get_regrow_timer()
