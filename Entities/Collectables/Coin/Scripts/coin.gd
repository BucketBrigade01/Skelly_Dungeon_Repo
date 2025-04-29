extends Area2D
class_name Coin

var collected : bool = false

func _ready() -> void:
	get_shine_timer()

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "collected":
		queue_free()
	elif $AnimatedSprite2D.animation == "shine":
		$AnimatedSprite2D.play("default")
		get_shine_timer()
		
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		collected = true
		$CollisionShape2D.set_deferred("disabled", true)
		Utils.set_coint_count(1)
		$AnimatedSprite2D.play("collected")
		$AudioStreamPlayer2D.play()

func get_shine_timer() -> void:
	await get_tree().create_timer(randf_range(3.0, 5.0)).timeout
	if !collected:
		$AnimatedSprite2D.play("shine")
	
