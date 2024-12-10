extends State
class_name LazerIdle

@export var lazer : LazerBeam
@export var line : Line2D

var difference : Vector2
var pixel_size : float = 1.0

func on_process(delta : float):
	# If Skelly comes in range start charging Lazer
	if difference.length() < 40 and lazer.enabled:
		transition.emit("charging")
	
	# Tracking Skelly	
	difference = lazer.bird.target.global_position - lazer.bird.position
	lazer.target_position = difference
	line.points[0] = snap_to_pixel(lazer.position)
	line.points[1] = snap_to_pixel(lazer.target_position)
	
func snap_to_pixel(point: Vector2) -> Vector2:
	return Vector2(
		floor(point.x / pixel_size) * pixel_size,
		floor(point.y / pixel_size) * pixel_size
	)

func enter():
	line.modulate = Color.RED
	line.modulate.a = 0.0
	line.width = 0.1
	lazer.lazer_fired = false
	
func exit():
	pass
