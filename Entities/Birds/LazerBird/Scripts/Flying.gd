extends State
class_name BirdFlying

@export var bird : LazerBird
@export var animation_sprite : AnimatedSprite2D
@export var speed : int
@export var ray_cast : RayCast2D

func on_physics_process(delta : float):
	var difference = bird.target.global_position - bird.global_position
	if difference.length() < 80:
		bird.velocity = difference * speed * delta
		if difference.x > 0:
			animation_sprite.flip_h = false
		else:
			animation_sprite.flip_h = true
	else:
		bird.velocity.y = -speed
		if ray_cast.is_colliding():
			bird.velocity = Vector2.ZERO
			transition.emit("idlehatched")
			
	bird.move_and_slide()
func enter():
	animation_sprite.play("flying")
	
func exit():
	animation_sprite.stop()
