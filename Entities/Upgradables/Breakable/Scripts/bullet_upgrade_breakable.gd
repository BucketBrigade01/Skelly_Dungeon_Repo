extends Area2D

@onready var animation := $AnimatedSprite2D
@onready var original_position := position.y

var time : float = 0.0
var freq : float = 1
var amp : float = 5


func _ready() -> void:
	animation.play("idle")

func _process(delta: float) -> void:
	time += delta
	
	position.y = original_position + sin(time * freq) * amp

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		$CollisionShape2D.set_deferred("disabled", true)
		animation.play("break")
		Utils.breakable_upgrade = true
		$BreakSound.play()
		$UpgradeSound.play()
		
func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
