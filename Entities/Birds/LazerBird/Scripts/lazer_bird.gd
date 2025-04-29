extends Enemy
class_name LazerBird

var speed : float = 30.0
var knock_back_direction : bool = false: 
	set = set_knockback
var on_screen : bool = false

func _ready() -> void:
	_set_target()
	$Sprite2D.visible = false

func _physics_process(_delta: float) -> void:
	
	if dead:
		velocity = Vector2.ZERO
	move_and_slide()

func set_knockback(value : bool) -> void:
	knock_back_direction = value

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	on_screen = false
