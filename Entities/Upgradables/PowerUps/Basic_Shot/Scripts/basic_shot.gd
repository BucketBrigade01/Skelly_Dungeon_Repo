class_name BasicShot extends Area2D

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var power_up_sound : AudioStreamPlayer = $AudioStreamPlayer
@onready var original_position := position.y

var time : float = 0.0
var freq : float = 1
var amp : float = 3

func _process(delta: float) -> void:
	time += delta
	
	position.y = original_position + sin(time * freq) * amp

func _on_area_entered(area):
	if area.is_in_group("Player"):
		Utils.player_power_ups['basic_shoot'] = true
		animation.play("collect")
		power_up_sound.play()

func _on_audio_stream_player_finished():
	queue_free()
