extends Node

var player_health : int = 3
var player_crouch_val : int = 0
var player_crouched : bool
var textbox_reading : bool = false

func _process(delta: float) -> void:
	player_crouch_val = clamp(player_crouch_val, 0, 20)
