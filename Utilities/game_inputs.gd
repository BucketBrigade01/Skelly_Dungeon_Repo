class_name GameInput extends Node

static func movment_input() -> float:
	var direction = Input.get_axis("left", "right")
	return direction 
	
static func jump_input() -> bool:
	var jump : bool = Input.is_action_just_pressed("jump")
	return jump
	
static func jump_pressed_input() -> bool:
	var jump : bool = Input.is_action_pressed("jump")
	return jump

static func hover_input() -> bool:
	var hover : bool = Input.is_action_pressed("hover")
	return hover
	
static func hover_released_input() -> bool:
	var hover : bool = Input.is_action_pressed("hover")
	return hover

static func boost_input() -> bool:
	var boost : bool = Input.is_action_pressed("boost")
	return boost
	
static func grab_input() -> bool:
	var grab : bool = Input.is_action_pressed("grab")
	return grab

static func aim_input() -> bool:
	var aim : bool = Input.is_action_pressed("aim")
	return aim

static func shoot_input() -> bool:
	var shoot : bool = Input.is_action_just_pressed("shoot")
	return shoot
