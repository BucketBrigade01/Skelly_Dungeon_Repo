extends Area2D

var direction : float = 1.0
var SPEED : int = 300
var in_air : bool = true

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	if in_air:
		position += transform.x * SPEED * direction * delta
	
	
func flip_projectile():
	direction = -1
	animated_sprite.flip_h = true

func _on_body_entered(body):
	if body is TileMap:
		in_air = false
		$CPUParticles2D.emitting = false
		$WorldEnvironment.environment.glow_enabled = false
		animated_sprite.play("wall_hit")
		
func _on_animated_sprite_2d_animation_finished():
	queue_free()


func _on_area_entered(area):
	if area.is_in_group("LazerBird"):
		in_air = false
		$CPUParticles2D.emitting = false
		$WorldEnvironment.environment.glow_enabled = false
		animated_sprite.play("wall_hit")
		$CollisionShape2D.set_deferred("disabled", true)



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
