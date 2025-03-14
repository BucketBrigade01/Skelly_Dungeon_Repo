class_name TransitionCameraZone extends Area2D

signal room_count(num_rooms_right, num_rooms_left, num_rooms_up, num_rooms_down)

@export var num_rooms_right := 1
@export var num_rooms_left := 1
@export var num_rooms_up := 1
@export var num_rooms_down := 1

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		emit_signal("room_count", num_rooms_right, num_rooms_left, num_rooms_up, num_rooms_down)
