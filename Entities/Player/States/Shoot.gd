extends State

@export var projectile_spawner : Marker2D
@export var character_body : CharacterBody2D
@export var animated_sprite : AnimatedSprite2D

var bullet = preload("res://Entities/Damagables/Projectiles/simple_projectile.tscn")

func on_process(delta : float):
	pass
	
func on_physics_process(delta : float):
	if character_body.previous_state == "jump":
		transition.emit("fall")
	else:
		transition.emit(character_body.previous_state)
	
func enter():
	var bullet_instance = bullet.instantiate()
	add_child(bullet_instance)
	if animated_sprite.flip_h:
		bullet_instance.flip_projectile()
	bullet_instance.position = projectile_spawner.global_position
	animated_sprite.play("hover")
	
func exit():
	character_body.previous_state = "shoot"
	animated_sprite.stop()
	

