extends CanvasLayer

@export var health_bar : ProgressBar

func _ready() -> void:
	health_bar.value = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Utils.player_health == 2:
		health_bar.value = 70
	if Utils.player_health == 1:
		health_bar.value = 35
	if Utils.player_health == 0:
		health_bar.value == 0
