extends Camera2D

@export var player : Player

var screen_max_limit : int 
var entered : bool = false
var limit_left_val : int
var player_room : Vector2
var SCREEN_MAX_X_LEFT : int
var SCREEN_MAX_X_RIGHT : int
var SCREEN_MAX_X_UP : int
var SCREEN_MAX_X_DOWN : int

const SCREEN_MAX_Y : int = 2
const SCREEN_SIZE : Vector2 = Vector2(256,224)

func _ready() -> void:
	var switch_node := get_tree().get_nodes_in_group("SwitchCamera")
	for node in switch_node:
		node.room_count.connect(set_rooms)

func _process(_delta: float) -> void:
	# Calculate which screen/room the player is in
	#if !player.player_camera_follow:
	#	player_room = (player.global_position / SCREEN_SIZE).floor()

	# Set camera limits based on the current room
	@warning_ignore("narrowing_conversion")
	limit_top = (player_room.y * SCREEN_SIZE.y - (SCREEN_SIZE.y * SCREEN_MAX_X_UP)) 
	@warning_ignore("narrowing_conversion")
	limit_bottom = player_room.y * SCREEN_SIZE.y + SCREEN_SIZE.y 
	@warning_ignore("narrowing_conversion")
	limit_left = player_room.x * SCREEN_SIZE.x - (SCREEN_SIZE.x * SCREEN_MAX_X_LEFT)
	@warning_ignore("narrowing_conversion")
	limit_right = (player_room.x * SCREEN_SIZE.x) + (SCREEN_SIZE.x * SCREEN_MAX_X_RIGHT)
	# Debug output
	#if temp_left_lim != limit_left or temp_right_lim != limit_right:
		#print("Room: ", player_room)
		#print("Room coords: ", player_room.y * SCREEN_SIZE.x)
		#print("Limits - Left: ", limit_left, " Right: ", limit_right)
		#print("Limits - Top: ", limit_top, " Bottom: ", limit_bottom)

func set_rooms(right, left, up, _down, _is_h) -> void:
	#print("left ", left, " right ", right)
	SCREEN_MAX_X_UP = up
	SCREEN_MAX_X_LEFT = left - 1
	SCREEN_MAX_X_RIGHT = right
	player_room = (player.global_position / SCREEN_SIZE).floor()
	
