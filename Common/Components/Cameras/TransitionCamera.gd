extends Camera2D

var current_screen : Vector2 = Vector2.ZERO

const SCREEN_SIZE : Vector2 = Vector2(256,224)

func _ready():
	top_level = true
	global_position = get_parent().global_position
	_update_screen(current_screen)

func _process(delta):
	var parent_screen : Vector2 = (get_parent().global_position / SCREEN_SIZE).floor()
	if not parent_screen.is_equal_approx(current_screen):
		_update_screen(parent_screen)

func _update_screen(new_screen : Vector2):
	current_screen = new_screen
	global_position = current_screen * SCREEN_SIZE + SCREEN_SIZE * 0.5

