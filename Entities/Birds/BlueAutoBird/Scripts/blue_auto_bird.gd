class_name BlueAutoBird extends Area2D

@onready var animation := $AnimatedSprite2D
@onready var original_position := position.y

var bullet : PackedScene = preload("res://Entities/Damagables/Projectiles/folllow_bullet/follow_bullet.tscn")

var target : Player
var time : float = 0.0
var freq : float = 1
var amp : float = 3
var distance : Vector2
var can_shoot : bool = false
var timer : SceneTreeTimer

func _ready() -> void:
	animation.play("idle")
	target = get_tree().get_nodes_in_group("Player")[0]
	
func _process(delta: float) -> void:
	time += delta
	
	position.y = original_position + sin(time * freq) * amp
	
	distance = (position.direction_to(target.position)).normalized()
	if sign(distance.x) == -1:
		animation.flip_h = false
	elif sign(distance.x) == 1:
		animation.flip_h = true
		
	if can_shoot:
		shoot()
	
func shoot() -> void:
	if get_tree().get_nodes_in_group("World")[0] != null:
		var current_animation_frame : int = animation.frame
		var curremt_animation_frame : float = animation.frame_progress
		animation.animation = "fire"
		get_animation_timer()
		
		animation.set_frame_and_progress(current_animation_frame, curremt_animation_frame)
		
		var bullet_instance = bullet.instantiate()
		bullet_instance.direction = distance
		bullet_instance.global_position = global_position
		get_parent().add_child(bullet_instance)
		
		var bullet_instance1 = bullet.instantiate()
		bullet_instance1.global_position = global_position 
		bullet_instance1.direction = distance + Vector2(0.2, 0.2 * -distance.x)
		get_parent().add_child(bullet_instance1)
		
		var bullet_instance2 = bullet.instantiate()
		bullet_instance2.global_position = global_position
		bullet_instance2.direction = distance + Vector2(-0.2, 0.2 * distance.x)
		get_parent().add_child(bullet_instance2)
		
		can_shoot = false
		get_shoot_timer()

func get_shoot_timer() -> void:
	print_debug("shoot")
	timer = get_tree().create_timer(randf_range(1.0, 2.0))
	await timer.timeout
	can_shoot = true

func get_animation_timer() -> void:
	await get_tree().create_timer(1).timeout
	animation.play("idle")

func _on_visible_on_screen_notifier_2d_screen_entered():
	get_shoot_timer()

func _on_visible_on_screen_notifier_2d_screen_exited():
	can_shoot = false
