extends Enemy
class_name Chicken 

@export var GRAVITY = 10
@export var HORIZONTAL_SPEED = 50
@export var VERTICAL_SPEED = -150

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var explode_area_collider : CollisionShape2D = $ExplostionBox/CollisionShape2D
@onready var ray1 : RayCast2D = $RayCast2D2
@onready var ray2 : RayCast2D = $RayCast2D
@onready var ray3 : RayCast2D = $RayCast2D3

var jump : bool = false
var direction : int = -1
var timer : float = 1.0
var explode_range : bool = false
var explode_timer : float = 0.0
var exploded : bool = false

func _ready() -> void:
	_set_target()
	explode_area_collider.set_deferred("disabled", true)
	get_jump_timer()
	
func _physics_process(delta) -> void:
	velocity.y += GRAVITY
	
	if jump and is_on_floor():
		velocity.y = VERTICAL_SPEED
		animation.play("jump")
		jump = false
		get_jump_timer()
		
	if is_on_floor():
		velocity.x = 0
	else:
		velocity.x = HORIZONTAL_SPEED * direction
	
	if (!ray1.is_colliding() or !ray2.is_colliding() or !ray3.is_colliding()) and is_on_floor():
		direction *= -1
		ray1.position.x *= -1
		ray2.position.x *= -1
		ray3.position.x *= -1
		get_flip_timer()
	
	if explode_range:
		direction = sign((position.direction_to(target.position).x))
		ray1.position.x = -ray1.position.x if animation.flip_h else ray1.position.x
		ray2.position.x = -ray2.position.x if animation.flip_h else ray2.position.x
		ray3.position.x = -ray3.position.x if animation.flip_h else ray3.position.x
		animation.flip_h = direction == 1
		if is_on_floor():
			velocity = Vector2.ZERO
			explode_timer += delta
			$AnimationPlayer.play("tick_down")
			if explode_timer > 2.0:
				explode()
	else:
		if !$AnimationPlayer.current_animation == "hit":
			$AnimationPlayer.play("RESET")
		explode_timer = 0.0
		
	move_and_slide()

func explode() -> void:
	exploded = true
	set_physics_process(false)
	animation.play("explode")
	$AnimationPlayer.play("RESET")
	$CollisionShape2D.set_deferred("disabled", true)
	get_explode_timer()
	
func get_explode_timer() -> void:
	await get_tree().create_timer(0.3).timeout
	$FuseBox/CollisionShape2D.set_deferred("disabled", true)
	$ExplostionBox/CollisionShape2D.set_deferred("disabled", true)

func get_flip_timer() -> void:
	await get_tree().create_timer(0.2).timeout
	animation.flip_h = direction == 1

func get_jump_timer() -> void:
	await get_tree().create_timer(timer).timeout
	if !exploded:
		animation.play("charge")

func _on_agro_box_area_entered(area):
	if area.is_in_group("Player"):
		timer = 0.25

func _on_agro_box_area_exited(area):
	if area.is_in_group("Player"):
		timer = 1.0

func _on_animated_sprite_2d_animation_finished():
	if animation.animation == "charge" and not exploded:
		jump = true
	elif animation.animation == "jump" and not exploded:
		animation.play("idle")
	elif animation.animation == "explode":
		queue_free()

func _on_fuse_box_area_entered(area):
	if area.is_in_group("Player"):
		explode_range = true

func _on_fuse_box_area_exited(area):
	if area.is_in_group("Player"):
		explode_range = false


func _on_hit_box_area_entered(area):
	if area.is_in_group("Bullet"):
		stats.take_damage(1)
		$AnimationPlayer.play("hit")
		if stats.get_health() == 0:
			$CollisionShape2D.set_deferred("disabled", true)
			$HitBox/CollisionShape2D.set_deferred("disabled", true)
			set_physics_process(false)
			explode()
