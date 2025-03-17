extends Area2D

@onready var original_position := position.y
@onready var animation_sprite := $AnimatedSprite2D

var time := 0.0
var freq : float = 1
var amp : float = 5

func _process(delta: float) -> void:
	time += delta
	
	position.y = original_position + sin(time * freq) * amp


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		$CollisionShape2D.set_deferred("disabled", true)
		animation_sprite.play("collected")
		Utils.set_health(3)
		$RegenSound.play()
		$BreakSound.play()

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
