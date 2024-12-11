extends Node2D

@export var world : Node2D

func _process(delta: float) -> void:
	if world.text_box_finished:
		$Barrier/CollisionShape2D.disabled = true


func _on_change_level_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Stages/world_1_level_1.tscn")
