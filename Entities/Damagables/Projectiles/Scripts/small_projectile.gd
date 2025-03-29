extends Area2D

var direction : float = 1.0
var SPEED : int = 300
var in_air : bool = true
var despawn: bool = false
var despawn_timer := 0.5

@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	get_despawn_timer()

func _physics_process(delta):
	if in_air:
		position += transform.x * SPEED * direction * delta
	else:
		position += transform.x * 0
		
	if despawn:
		in_air = false
		$CPUParticles2D.emitting = false
		#$WorldEnvironment.environment.glow_enabled = false
		animated_sprite.play("wall_hit")
	
func flip_projectile():
	direction = -1
	animated_sprite.flip_h = true

func _on_body_entered(body):
	if body is TileMap:
		$CollisionShape2D.set_deferred("disabled", true)
		in_air = false
		$CPUParticles2D.emitting = false
		animated_sprite.play("wall_hit")
		$BreakSound.play()
		
func _on_animated_sprite_2d_animation_finished():
	queue_free()


func _on_area_entered(area):
	if area.is_in_group("LazerBird"):
		in_air = false
		$CPUParticles2D.emitting = false
		animated_sprite.play("wall_hit")
		$BreakSound.play()
	if area.is_in_group("Player"):
		in_air = false
		$CollisionShape2D.set_deferred("disabled", true)
		$BreakSound.play()
		animated_sprite.play("wall_hit")
		$CPUParticles2D.emitting = false

func get_despawn_timer() -> void:
	await get_tree().create_timer(despawn_timer).timeout
	despawn = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
