extends StaticBody2D

@export var direction := 1
@export var SPEED := 1

@onready var left_ray := $WallCheck/RayCast2D
@onready var right_ray := $WallCheck/RayCast2D2

var change_dir_timer := 0.3
var bumping_wall := false

func _physics_process(delta: float) -> void:
	if (left_ray.get_collider() or right_ray.get_collider()) and !bumping_wall:
		direction *= -1
		bumping_wall = true
		get_bumped_wall_timer()
	move_and_collide(SPEED * direction * transform.x)
	
func get_bumped_wall_timer() -> void:
	await get_tree().create_timer(change_dir_timer).timeout
	bumping_wall = false
