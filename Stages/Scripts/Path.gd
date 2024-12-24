extends Path2D

@export var world : Node2D

var SPEED = 0.3
var bird_active : bool = false

func _process(delta: float) -> void:
	if bird_active:
		$PathFollow2D.progress_ratio += SPEED * delta
	if int($PathFollow2D.progress) == 182:
		world.interact_button = true
		if GameInput.interact_input():
			world.activate_textbox = true

func _on_bird_active_body_entered(_body: Node2D) -> void:
	bird_active = true
