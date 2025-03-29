extends State

@export var penguin : Penguin
@export var animation : AnimatedSprite2D
@export var hit_collider : CollisionShape2D 
@export var FRICTION : int = 40

func _ready() -> void:
	hit_collider.set_deferred("disabled", true)

func _physics_process(delta: float) -> void:
	penguin.velocity.x = move_toward(penguin.velocity.x, 0, FRICTION)
	
	var difference = penguin.global_position.distance_to(penguin.target.position)
	var direction = penguin.global_position.direction_to(penguin.target.position)
	
	penguin.move_and_slide()

	
	if animation.frame > 6 and animation.animation == "punch":
		hit_collider.set_deferred("disabled", false)
	
	if penguin.can_icefall:
		transition.emit("icefall")
	
func enter():
	if animation.flip_h:
		hit_collider.position.x = 34
	elif !animation.flip_h:
		hit_collider.position.x = -34
	penguin.current_state = "punch"
	animation.play("punch")
	
func exit():
	penguin.can_punch = false
	penguin.previous_state = "punch"
	hit_collider.set_deferred("disabled", true)
	animation.stop()

func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "punch":
		transition.emit("idle")
