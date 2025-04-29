extends Path2D

@onready var path_follow : PathFollow2D = $PathFollow2D
@onready var animation_player := $AnimationPlayer
@onready var animation : AnimatedSprite2D = $AnimatableBody2D/AnimatedSprite2D
@onready var ray : RayCast2D = $AnimatableBody2D/RayCast2D

var shake : bool = false
var original_position : Vector2 

var time : float = 0.0
var freq : float = 100
var amp : float = 0.5
var timer : SceneTreeTimer

func _ready() -> void:
	path_follow.progress_ratio = 0.0
	original_position = global_position
	$AnimatableBody2D/JumpDetection/CollisionShape2D.set_deferred("disabled", true)
	
func _physics_process(delta : float) -> void:
	time += delta
	
	if shake and timer.time_left:
		global_position.y = original_position.y + sin(time * freq) * amp
	elif shake and not timer.time_left:
		# Reset position when shake ends
		global_position = original_position
		shake = false
	
	if ray.is_colliding():
		animation.play("break")
		animation_player.pause()
		$AnimatableBody2D/CollisionShape2D.set_deferred("disabled", true)
		$AnimatableBody2D/JumpDetection/CollisionShape2D.set_deferred("disabled", true)
		
func _on_player_detection_area_entered(area):
	if area.is_in_group("Player"):
		shake = true
		get_shake_timer()

func get_shake_timer() -> void:
	timer = get_tree().create_timer(1.0)
	await timer.timeout
	shake = false
	animation_player.play("fall")
	$AnimatableBody2D/JumpDetection/CollisionShape2D.set_deferred("disabled", false)
	
func _on_animated_sprite_2d_animation_finished():
	queue_free()
