extends Camera2D

@export var player : Player

var current_screen : Vector2 = Vector2.ZERO
var timer : SceneTreeTimer

const SCREEN_SIZE : Vector2 = Vector2(256,224)

func _ready():
	top_level = true
	global_position = player.global_position
	_update_screen(current_screen)
	timer = get_tree().create_timer(2)

func _process(_delta):
	var parent_screen : Vector2 = (player.global_position / SCREEN_SIZE).floor()
	if timer.time_left == 0:
		limit_smoothed = true
		position_smoothing_enabled = true
		
	if player.player_camera_follow:
		limit_smoothed = false
		position_smoothing_enabled = false
	
	if not parent_screen.is_equal_approx(current_screen):
		_update_screen(parent_screen)

func _update_screen(new_screen : Vector2):
	current_screen = new_screen
	global_position = current_screen * SCREEN_SIZE + SCREEN_SIZE * 0.5
