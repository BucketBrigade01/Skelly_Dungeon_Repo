class_name AutoBullet extends Area2D

@export var SPEED : float = 100
@export var particle : CPUParticles2D

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var init_position : Vector2 = position

var direction : Vector2

func _ready() -> void:
	particle.gravity = Vector2(45 * direction.x, 45 * direction.y)

func _process(delta) -> void:
	position += direction * SPEED * delta
	
func _on_body_entered(body):
	if body is TileMap:
		$CollisionShape2D.set_deferred("disabled", true)
		set_process(false)
		animation.play("collide")
	
func _on_animated_sprite_2d_animation_finished():
	if animation.animation == "collide":
		particle.emitting = false
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("Player"):
		$CollisionShape2D.set_deferred("disabled", true)
		set_process(false)
		animation.play("collide")
