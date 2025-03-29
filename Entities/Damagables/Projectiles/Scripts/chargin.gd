extends State
class_name LazerCharge

@export var lazer : LazerBeam
@export var line : Line2D
@export var glow : WorldEnvironment
@export var charge_duration : float

var difference : Vector2
var pixel_size : float = 1.0
var tween : Tween

func on_process(_delta : float):
	
	if !lazer.on_screen:
		return
	
	# If Skelly gets away or Bird dies
	if difference.length() > 70 or lazer.bird.stats.get_health() == 0:
		transition.emit("fade")
	
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

func on_tween_finished():
	transition.emit("fire")

func enter():
	#glow.set_deferred("glow_enabled", true)
	tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(line, "modulate:a", 1.0, charge_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.tween_property(line, "width", 1.0, charge_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.connect("finished", on_tween_finished)
	pass

func exit():
	tween.stop()
