extends Area2D

@onready var animated_sprite = $AnimatedSprite2D

var direction : float = 1.0
var SPEED : int = 150
var in_air : bool = true
var despawn_timer := 0.5

func _physics_process(delta):
	if in_air:
		position += transform.y * SPEED * direction * delta
	else:
		position += transform.y * 0
		
func _on_body_entered(body: Node2D) -> void:
	if body is TileMap:
		$CollisionShape2D.set_deferred("disabled", true)
		in_air = false
		$CPUParticles2D.emitting = false
		animated_sprite.play("break")
		$BreakSound.play()
	if body is Player:
		in_air = false
		$CollisionShape2D.set_deferred("disabled", true)
		$BreakSound.play()
		animated_sprite.play("break")
		$CPUParticles2D.emitting = false
		$WorldEnvironment.environment.glow_enabled = false

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
