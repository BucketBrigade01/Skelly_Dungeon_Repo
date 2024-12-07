extends CharacterBody2D
class_name LazerBird

@export var target : Player
@export var stats : EnemyStats
@export var animation_player : AnimationPlayer

var dead : bool = false
var speed : float = 30.0

func _physics_process(delta: float) -> void:
	if dead:
		velocity = Vector2.ZERO
	move_and_slide()

func _on_hurt_box_area_entered(area):
	if area.is_in_group("Bullet"):
		stats.take_damage(1)
		$AnimationPlayer.play("hit")
		
		if stats.get_health() == 0:
			dead = true
			$AnimatedSprite2D.play("death")

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		$StateMachine.queue_free()
		queue_free()
