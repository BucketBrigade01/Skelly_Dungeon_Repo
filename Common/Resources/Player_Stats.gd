extends Resource
class_name PlayerStats

@export var attack : int
@export var health : int

func take_damage(amount : int) -> void:
	health -= amount

func get_health() -> int:
	return health
