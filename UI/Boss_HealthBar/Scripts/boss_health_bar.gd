class_name BossHealth extends CanvasLayer

@onready var health_bar : ProgressBar = $MarginContainer/ProgressBar

func _ready():
	health_bar.value = Utils.boss_health
	Utils.connect("update_boss_health", update)

func update(health):
	health_bar.value = health
