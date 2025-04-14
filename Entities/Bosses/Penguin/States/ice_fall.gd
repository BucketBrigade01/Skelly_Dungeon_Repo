extends State

@export var penguin : Penguin
@export var animation : AnimatedSprite2D

@onready var ice_ball = preload("res://Entities/Damagables/Projectiles/Ice_Bullet/ice_bullet.tscn")
@onready var belly_collider : CollisionShape2D = $"../../BellyZone/CollisionShape2D"
@onready var hit_collider : CollisionShape2D = $"../../HitZone/CollisionShape2D"
@onready var damage_collider : CollisionShape2D = $"../../DamageZone/CollisionShape2D"
@onready var ice_fall_sound := $"../../IceFallSound"

func spawn_ice() -> void:
	var ice_ball_instance = ice_ball.instantiate()
	ice_ball_instance.global_position = Vector2(randi_range(40, 210), randi_range(-10, -20))
	penguin.get_parent().add_child(ice_ball_instance)
	get_ice_timer()

func enter():
	ice_fall_sound.play()
	if animation.flip_h:
		belly_collider.position.x = 16.25
		hit_collider.position.x = -17.0
		damage_collider.position.x = 34.0
	else:
		belly_collider.position.x = -16.25
		hit_collider.position.x = 17.0
		damage_collider.position.x = -34.0
	if penguin.dying == true:
		transition.emit("die")
	animation.play("ice_fall")
	penguin.current_state = "icefall"
	get_ice_timer()
	get_idle_timer()
	
func exit():
	penguin.previous_state = "icefall"
	penguin.can_icefall = false
	penguin.get_icefall_timer()
	animation.stop()

func get_idle_timer() -> void:
	await get_tree().create_timer(5).timeout
	transition.emit("walk")

func get_ice_timer() -> void:
	await get_tree().create_timer(0.25).timeout
	if penguin.current_state == "icefall":
		spawn_ice()
