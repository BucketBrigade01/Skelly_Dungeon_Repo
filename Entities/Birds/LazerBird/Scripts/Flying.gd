extends State
class_name BirdFlying

@export var bird : LazerBird
@export var animation_sprite : AnimatedSprite2D
@export var speed : int
@export var ray_cast : RayCast2D
@export var lazer : Lazer
@export var upward_speed : int

func on_physics_process(delta : float):
	var difference = bird.target.global_position - bird.global_position
	
	if difference.length() < 80 and difference.length() > 30 and bird.stats.get_health() != 0:
		bird.velocity = difference * speed * delta
		if difference.x > 0:
			animation_sprite.flip_h = false
		else:
			animation_sprite.flip_h = true
			
	elif difference.length() < 30:
		move_toward(bird.velocity.x, 0.0, bird.speed)
		if bird.stats.get_health() != 0:
			lazer.enabled = true
		else:
			lazer.enabled = false
			
	else:
		lazer.enabled = false
		if bird.stats.get_health() != 0:
			bird.velocity.y = -upward_speed
		if ray_cast.is_colliding():
			bird.velocity = Vector2.ZERO
			transition.emit("idlehatched")
			
	bird.move_and_slide()
func enter():
	animation_sprite.play("flying")
	
func exit():
	animation_sprite.stop()
