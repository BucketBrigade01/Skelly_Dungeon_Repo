extends StaticBody2D

@export_flags("first", "mid", "last") var spawn_point := 0

func _on_detection_zone_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet"):
		$NotActive.visible = false
		$Active.visible = true
		Utils.player_spawnpoint = spawn_point
		$SpawnSound.play()
