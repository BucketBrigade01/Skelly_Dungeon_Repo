extends RayCast2D
class_name Lazer

@export var bird : LazerBird
@export var line : Line2D

var difference : Vector2
var pixel_size : float
var lazer_fired : bool = false

func _ready() -> void:
	pixel_size = 1.0
	line.points = [position, position]
	line.modulate.a = 0
	
func _process(delta: float) -> void:
	if enabled:
		# This is for the initial laser fade in event
		if line.modulate.a != 1.0 and not lazer_fired:
			var tween = get_tree().create_tween()
			tween.tween_property(line, "modulate:a", 1.0, 3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
			difference = bird.target.global_position - bird.position
			target_position = difference
			line.points[0] = snap_to_pixel(position)
			line.points[1] = snap_to_pixel(target_position)
		
		if line.modulate.a == 1.0:
			var tween = get_tree().create_tween()
			tween.tween_property(line, "modulate", Color(1, 1, 1, 1), 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
			tween.tween_property(line, "modulate:a", 0.0, 1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		
	else:
		# This is if the bird dies we want the laser to turn off fast
		if bird.stats.get_health() == 0:
			var tween = get_tree().create_tween()
			tween.tween_property(line, "modulate:a", 0.0, 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		
		# This is so that we still track if modulate is not 0
		if line.modulate.a != 0.0:
			difference = bird.target.global_position - bird.position
			target_position = difference
			line.points[0] = snap_to_pixel(position)
			line.points[1] = snap_to_pixel(target_position)
		
		# This is our regular laser fade, turns on if player is out of sight
		var tween = get_tree().create_tween()
		tween.tween_property(line, "modulate:a", 0.0, 1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		
func snap_to_pixel(point: Vector2) -> Vector2:
	return Vector2(
		floor(point.x / pixel_size) * pixel_size,
		floor(point.y / pixel_size) * pixel_size
	)
