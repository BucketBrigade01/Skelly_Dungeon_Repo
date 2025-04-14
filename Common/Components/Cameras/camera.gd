extends Camera2D

@onready var player: Player = get_parent().get_node("Player")

const SCREEN_WIDTH: int = 256
const SCREEN_HEIGHT: int = 224

enum CameraMode { 
	FIXED = 0,  # Camera stays fixed at room center
	FOLLOW = 1, # Camera follows player (with room boundaries)
}
