extends State
class_name LazerFade

@export var lazer : LazerBeam
@export var line : Line2D
@export var glow : WorldEnvironment

var difference : Vector2
var pixel_size : float = 1.0
var tween : Tween

func on_process(_delta : float):
	
	if !lazer.on_screen:
		return
	
	# Send to chargin if Skelly comes back in range
	if difference.length() < 60 and not lazer.lazer_fired:
		transition.emit("Charging")
	
	if lazer.bird.stats.get_health() == 0:
		tween.kill()
		transition.emit("idle")
	
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
	#glow.environment.glow_enabled = false
	transition.emit("idle")

func enter():
	# Fade out slow as Skelly gets out of range
	# IF the bird dies then the fade out is faster
	if lazer.bird.stats.get_health() != 0:
		if !lazer.lazer_fired:
			tween = get_tree().create_tween()
			tween.tween_property(line, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
			tween.connect("finished", on_tween_finished)
		else:
			tween = get_tree().create_tween()
			tween.tween_property(line, "modulate:a", 0.0, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
			tween.connect("finished", on_tween_finished)
	else:
		tween = get_tree().create_tween().set_loops(1)
		tween.tween_property(line, "modulate:a", 0.0, 0.1)
		tween.connect("finished", on_tween_finished)
	
func exit():
	tween.stop()
