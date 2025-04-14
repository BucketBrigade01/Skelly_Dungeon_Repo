extends CharacterBody2D
class_name LazerBird

@export var target : Player
@export var stats : EnemyStats
@export var animation_player : AnimationPlayer

var dead : bool = false
var speed : float = 30.0
var knock_back_direction : bool = false
var on_screen : bool = false

func _ready() -> void:
	$Sprite2D.visible = false

func _physics_process(_delta: float) -> void:
	
	if dead:
		velocity = Vector2.ZERO
	move_and_slide()

func _on_hurt_box_area_entered(area):
	if area.is_in_group("Bullet"):
		stats.take_damage(1)
		$AnimationPlayer.play("hit")
		knock_back_direction = true
		$HurtSound.play()
		if stats.get_health() == 0:
			$CollisionShape2D.set_deferred("disabled", true)
			$HurtBox/CollisionShape2D.set_deferred("disabled", true)
			dead = true
			$DeadSound.play()
			$AnimatedSprite2D.play("death")

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		$StateMachine.queue_free()
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	on_screen = false
