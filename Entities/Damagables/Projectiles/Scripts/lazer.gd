extends RayCast2D
class_name LazerBeam

@export var bird : LazerBird

var difference : Vector2
var pixel_size : float
var lazer_fired : bool = false
var on_screen : bool = false

func _ready() -> void:
	pixel_size = 1.0
	$Line2D.points = [position, position]
	$Line2D.modulate.a = 0
	
func _process(_delta):
	if bird.dead:
		set_physics_process(false)
		set_process(false)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_screen = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	on_screen = false
