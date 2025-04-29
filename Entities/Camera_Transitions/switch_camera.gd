class_name TransitionCameraZone extends Area2D

signal room_count(num_rooms_right, num_rooms_left, num_rooms_up, num_rooms_down, is_horizontal)

@export var camera : CombinedCamera
@export var num_rooms_right := 1
@export var num_rooms_left := 1
@export var num_rooms_up := 1
@export var num_rooms_down := 1
@export var is_horizontal : bool = true
@export var switch_collider_id : int = 0

func _on_area_entered(area):
	if area.is_in_group("Player"):
		camera.change_state(camera.CameraStates.FOLLOW)
		emit_signal("room_count", num_rooms_right, num_rooms_left, num_rooms_up, num_rooms_down, is_horizontal)
