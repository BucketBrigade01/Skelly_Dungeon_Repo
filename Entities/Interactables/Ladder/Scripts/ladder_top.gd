extends StaticBody2D

var target : Player

func _ready() -> void:
	set_process(false)
	$CollisionShape2D.set_deferred("disabled", false)

func _process(delta : float) -> void:
	if !target.can_climb and Input.is_action_just_pressed("down"):
		$CollisionShape2D.set_deferred("disabled", true)

func _on_player_detection_body_entered(body):
	if body is Player:
		target = body
		set_process(true)

func _on_player_detection_body_exited(body):
	if body is Player:
		set_process(false)
		$CollisionShape2D.set_deferred("disabled", false)
