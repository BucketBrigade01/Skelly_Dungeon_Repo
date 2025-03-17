extends CanvasLayer

@export var health_bar : ProgressBar

func _ready() -> void:
	health_bar.value = 100
	Utils.connect("update_world_stats", update_stats)


func update_stats(health, coin, breakable) -> void:
	if health == 3:
		health_bar.value = 100
	if health == 2:
		health_bar.value = 70
	if health == 1:
		health_bar.value = 35
	if health == 0:
		health_bar.value = 0
