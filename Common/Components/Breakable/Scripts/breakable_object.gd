extends Node
class_name BreakableObject

@export var body_collider : CollisionShape2D
@export var hurt_box : HurtBox
@export var animated_sprite : AnimatedSprite2D
@export var break_sound : AudioStreamPlayer2D

func break_object() -> void:
	break_sound.play()
	break_sound.finished.connect(_on_audio_stream_player_2d_finished)
	body_collider.set_deferred("disabled", true)
	hurt_box.disable_collision()
	animated_sprite.play("break")
	
func _on_audio_stream_player_2d_finished():
	queue_free()
