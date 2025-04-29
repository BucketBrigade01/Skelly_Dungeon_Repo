class_name CombinedCamera extends Camera2D

@onready var player: Player = get_parent().get_node("Player")
@onready var SCREEN_SIZE : Vector2 = get_viewport_rect().size

enum CameraStates {SNAP, FOLLOW}
enum RoomState {HORIZONTAL, VERTICAL}

var SCREEN_MAX_X_LEFT : int
var SCREEN_MAX_X_RIGHT : int
var SCREEN_MAX_X_UP : int
var SCREEN_MAX_X_DOWN : int
var player_room : Vector2
var is_horizontal_mode : bool 

var current_state : CameraStates 
var smoothing_timer : SceneTreeTimer
var current_room_state : RoomState
var room_manager_complete : bool 

func _ready() -> void:
	change_state(CameraStates.SNAP)
	set_snap_screen_position()
	await get_tree().physics_frame
	get_smoothing_timer()
	var switch_node := get_tree().get_nodes_in_group("SwitchCamera")
	if switch_node != null:
		for node in switch_node:
			node.room_count.connect(set_rooms)

func _physics_process(_delta: float) -> void:
	
	match current_state:
		CameraStates.SNAP:
			set_snap_screen_position()
		CameraStates.FOLLOW:
			set_follow_screen_position()
	if smoothing_timer.time_left == 0:
		position_smoothing_enabled = true
		position_smoothing_speed = 7.0
	
func set_snap_screen_position() -> void:
	var player_pos = player.global_position
	var x = floor(player_pos.x / SCREEN_SIZE.x) * SCREEN_SIZE.x + SCREEN_SIZE.x / 2
	var y = floor(player_pos.y / SCREEN_SIZE.y) * SCREEN_SIZE.y + SCREEN_SIZE. y / 2
	global_position = Vector2(x,y)
	
func set_follow_screen_position() -> void:
	
	if current_room_state == null or !room_manager_complete:
		return
	
	var player_pos = player.global_position
	
	if current_room_state == RoomState.HORIZONTAL:
		var x = player_pos.x
		global_position.x = player_pos.x
	elif  current_room_state == RoomState.VERTICAL:
		var y = player_pos.y
		global_position.y = player_pos.y
	
	
func set_rooms(right, left, up, down, is_h) -> void:
	#print("left ", left, " right ", right)
	SCREEN_MAX_X_UP = up
	SCREEN_MAX_X_LEFT = left - 1
	SCREEN_MAX_X_RIGHT = right
	SCREEN_MAX_X_DOWN = down 
	player_room = (player.global_position / SCREEN_SIZE).floor()
	if current_state == CameraStates.FOLLOW:
		
		@warning_ignore("narrowing_conversion")
		limit_top = (player_room.y * SCREEN_SIZE.y - (SCREEN_SIZE.y * SCREEN_MAX_X_UP)) 
		@warning_ignore("narrowing_conversion")
		limit_bottom = player_room.y * SCREEN_SIZE.y + (SCREEN_SIZE.y * SCREEN_MAX_X_DOWN)
		@warning_ignore("narrowing_conversion")
		limit_left = player_room.x * SCREEN_SIZE.x - (SCREEN_SIZE.x * SCREEN_MAX_X_LEFT)
		@warning_ignore("narrowing_conversion")
		limit_right = (player_room.x * SCREEN_SIZE.x) + (SCREEN_SIZE.x * SCREEN_MAX_X_RIGHT)
		if is_h:
			current_room_state = RoomState.HORIZONTAL
		else:
			current_room_state = RoomState.VERTICAL
	room_manager_complete = true

func change_state(new_state : CameraStates) -> void:
	
	if current_state == new_state:
		return
	
	current_state = new_state
	
	match current_state:
		CameraStates.SNAP:
			get_smoothing_timer()
			position_smoothing_enabled = true
			limit_smoothed = true
			drag_horizontal_enabled = false
			drag_vertical_enabled = false
			if current_state == CameraStates.SNAP:
				limit_top = -1000000
				limit_bottom = 1000000
				limit_left = -1000000
				limit_right = 1000000
		CameraStates.FOLLOW:
			room_manager_complete = false
			drag_horizontal_enabled = true
			drag_vertical_enabled = true
			
func get_smoothing_timer() -> void:
	smoothing_timer = get_tree().create_timer(0.1)
	await smoothing_timer.timeout
	
