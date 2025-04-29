extends  Area2D

@export var camera : CombinedCamera

func _on_area_entered(area):
	if area.is_in_group("Player"):
		camera.change_state(camera.CameraStates.SNAP)
