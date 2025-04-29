extends Enemy
class_name UpDownBird 

@export var SPEED : float = 100
@export var UP_SPEED : float = 50

@onready var origin_position = position
@onready var top_ray : RayCast2D = $TopRay
@onready var bottom_ray : RayCast2D = $BottomRay

var attack : bool = false
var direction : int = 1
var off_screen : bool = true
var timer_active = true
var timer : SceneTreeTimer

func _ready() -> void:
	_set_target()

func _physics_process(delta):
	if attack:
		velocity.y += SPEED * delta
	
	if is_on_floor() or !attack:
		attack = false
		velocity.y -= UP_SPEED * delta
		if floor(position) == origin_position:
			if off_screen:
				set_physics_process(false)
			if !timer_active:
				get_updown_timer()
	move_and_slide()

func get_updown_timer() -> void:
	timer_active = true
	timer = get_tree().create_timer(randf_range(1, 2))
	await timer.timeout
	if !off_screen:
		timer_active = false
		attack = true

func _on_hit_b_ox_area_entered(area):
	if area.is_in_group("Bullet"):
		take_damage()

func _on_visible_on_screen_notifier_2d_screen_entered():
	set_physics_process(true)
	get_updown_timer()
	off_screen = false

func _on_visible_on_screen_notifier_2d_screen_exited():
	off_screen = true
	timer.set_time_left(0.0)
		
