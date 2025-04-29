extends Enemy
class_name SquishBird


var player_on : bool = false

func _ready() -> void:
	_set_target()

func _on_detection_box_body_entered(body: Node2D) -> void:
	if body is Player:
		player_on = true


func _on_detection_box_body_exited(body: Node2D) -> void:
	if body is Player:
		player_on = false
