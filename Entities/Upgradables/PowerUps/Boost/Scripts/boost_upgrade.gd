class_name BoostUpgrade extends Area2D

@onready var animation := $AnimatedSprite2D
@onready var original_position := position.y

var time : float = 0.0
var freq : float = 1
var amp : float = 3


func _ready() -> void:
	animation.play("idle")

func _process(delta: float) -> void:
	time += delta
	
	position.y = original_position + sin(time * freq) * amp

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		$AudioStreamPlayer.play()
		$CollisionShape2D.set_deferred("disabled", true)
		animation.play("collect")
		Utils.player_power_ups['boost'] = true
		$BreakSound.play()
		$UpgradeSound.play()


func _on_audio_stream_player_finished():
	queue_free()
