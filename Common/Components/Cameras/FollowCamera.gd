extends Camera2D

var screen_max_limit : int 
var entered : bool = false
var limit_left_val : int

const SCREEN_SIZE : Vector2 = Vector2(256,224)

func _process(_delta):
	var parent_screen : Vector2 = (get_parent().global_position / SCREEN_SIZE).floor()
	limit_top = SCREEN_SIZE.y * parent_screen.y
	limit_bottom = (SCREEN_SIZE.y * parent_screen.y) - SCREEN_SIZE.y
	if enabled and not entered:
		limit_left_val = parent_screen.x * SCREEN_SIZE.x
		entered = true
	limit_left = limit_left_val

