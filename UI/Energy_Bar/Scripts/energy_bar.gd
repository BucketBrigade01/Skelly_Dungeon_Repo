extends CanvasLayer

@export var energy : ProgressBar

var timer : SceneTreeTimer
var timer_started : bool = false

func _ready() -> void:
	energy.value = 0


func _process(_delta: float) -> void:
	energy.value = Utils.player_crouch_val * 5
	
	if not Utils.player_crouched and Utils.player_crouch_val > 0 and not timer_started: 
		timer = get_tree().create_timer(0.05)
		timer_started = true
	
	if timer != null and not Utils.player_crouched and Utils.player_crouch_val > 0:
		if timer.time_left == 0:
			Utils.player_crouch_val -= 1
			timer_started = false
