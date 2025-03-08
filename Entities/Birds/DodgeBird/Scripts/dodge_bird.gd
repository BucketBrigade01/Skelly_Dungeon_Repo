extends CharacterBody2D
class_name DodgeBird

@onready var projectile = preload("res://Entities/Damagables/Projectiles/small_projectile.tscn")

var randome_time : int
var can_shoot : bool = false
var shoot_timer_node : Timer

func _ready() -> void:
	$AnimatedSprite2D.play("idle")
	shoot()
	start_timer()

func _process(delta: float) -> void:

	if can_shoot:
		shoot()
		start_timer()
		can_shoot = false

func shoot() -> void:
	var proj_inst = projectile.instantiate()
	add_child(proj_inst)
	proj_inst.position = $Marker2D.position

func start_timer() -> void:
	shoot_timer_node = Timer.new()
	shoot_timer_node.wait_time = randf_range(1.5, 2.5)
	shoot_timer_node.one_shot = true
	shoot_timer_node.connect("timeout", reset_shoot_state)
	add_child(shoot_timer_node)
	shoot_timer_node.start()
	
func reset_shoot_state() -> void:
	can_shoot = true
	
