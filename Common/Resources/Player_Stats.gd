extends Resource
class_name PlayerStats

@export var attack : int
@export var health : int
@export var coins : int = 0

func take_damage(amount : int) -> void:
	health -= amount

func increase_coins() -> void:
	coins += 1

func get_coins() -> int:
	return coins

func get_health() -> int:
	return health
