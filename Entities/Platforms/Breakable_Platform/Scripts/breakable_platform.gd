extends StaticBody2D


@onready var animation := $AnimatedSprite2D
@onready var platform_collider := $CollisionShape2D
@onready var detection_collider := $DetectionArea/CollisionShape2D

func respawn_platform() -> void:
	animation.play("idle")
	platform_collider.set_deferred("disabled", false)
	detection_collider.set_deferred("disabled", false)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		animation.play("break")

func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "break":
		animation.play("broken")
		platform_collider.set_deferred("disabled", true)
		detection_collider.set_deferred("disabled", true)
		get_respawn_timer()

func get_respawn_timer() -> void:
	await get_tree().create_timer(2).timeout
	respawn_platform()
