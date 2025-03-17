extends Area2D

var player_entered := false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_entered and Utils.has_key:
		print_debug("Go to boss room")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered = true

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_entered = false
