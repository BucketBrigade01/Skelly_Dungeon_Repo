extends State
class_name LazerFire

@export var lazer : LazerBeam
@export var line : Line2D
@export var glow : WorldEnvironment

var difference : Vector2
var pixel_size : float = 1.0
var tween : Tween

func on_process(_delta : float):
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
	transition.emit("fade")

func enter():
	lazer.lazer_fired = true
	tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(line, "width", 5, 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.tween_property(line, "modulate", Color.DEEP_SKY_BLUE, 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.chain().tween_property(line, "width", 0.5, 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.connect("finished", on_tween_finished)
	pass
	
func exit():
	tween.stop()
	glow.environment.glow_enabled = false
	Utils.player_health -= 1
