extends State

@export var chicken : Chicken
@export var animation : AnimatedSprite2D
@export var ray1 : RayCast2D
@export var ray2 : RayCast2D

var jump: bool = false
var direction : int = 1
var flip_timer : SceneTreeTimer
var jump_timer : SceneTreeTimer
var in_air_on_entered : bool = false

func on_physics_process(_delta : float):
	chicken.velocity.y += 10
	
	if in_air_on_entered:
		get_jump_timer()
		in_air_on_entered = false
	
	if jump:
		chicken.velocity.y = -150
		jump = false
		get_jump_timer()
	
	if chicken.is_on_floor():
		chicken.velocity.x = 0
		if (!ray1.is_colliding() or !ray2.is_colliding()):
			ray1.position.x = abs(ray1.position.x) * direction
			ray2.position.x = abs(ray2.position.x) * direction
			get_flip_timer()
	else:
		if sign(chicken.velocity.y) == -1:
			animation.play("jump")
		chicken.velocity.x = -50 * direction
	
	chicken.move_and_slide()
	
	if chicken.target_distance > 80:
		transition.emit("idle")
	
	if chicken.velocity.y > 0:
		transition.emit("fall")
	
func enter():
	if chicken.is_on_floor():
		get_jump_timer()
	else:
		in_air_on_entered = true
	animation.play("idle")
	chicken.cur_state = "agro"
	
func exit():
	jump_timer.set_time_left(0.0)
	chicken.prev_state = "agro"
	
func get_flip_timer() -> void:
	flip_timer = get_tree().create_timer(0.3)
	await flip_timer.timeout
	direction *= -1	
	animation.flip_h = direction == -1

func get_jump_timer() -> void:
	jump_timer = get_tree().create_timer(0.5)
	await jump_timer.timeout
	animation.play("charge")	

func _on_animated_sprite_2d_animation_finished():
	if animation.animation == "charge":
		jump = true
	if animation.animation == "jump":
		animation.play("idle")
