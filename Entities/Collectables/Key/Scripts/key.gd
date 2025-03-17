class_name RegularKey extends Area2D

@export var world : Node2D

@onready var original_position = position.y

var time := 0.0
var freq : float = 1
var amp : float = 5

func _ready() -> void:
	visible = false
	world.connect("objective_complete_signal", spawn_key)

func _process(delta: float) -> void:
	if visible:
		time += delta
		position.y = original_position + sin(time * freq) * amp
	
func spawn_key() -> void:
	visible = true

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Utils.has_key = true
		queue_free()
