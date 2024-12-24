extends Camera2D

@export var player : Player

var screen_max_limit : int 
var entered : bool = false
var limit_left_val : int

const SCREEN_MAX_X : int = 3
const SCREEN_MAX_Y : int = 2
const SCREEN_SIZE : Vector2 = Vector2(256,224)

func _process(_delta: float) -> void:
	var player_position : Vector2 = (player.global_position / SCREEN_SIZE).floor()
	@warning_ignore("narrowing_conversion")
	limit_top = 224 * ceilf(abs(player.global_position.y/224)) * player_position.y
	@warning_ignore("narrowing_conversion")
	limit_left = 256 * floorf(absf(player.global_position.x/256)) + (-256)
	@warning_ignore("narrowing_conversion")
	limit_bottom = ceilf(abs(player.global_position.y/224)) * player_position.y
