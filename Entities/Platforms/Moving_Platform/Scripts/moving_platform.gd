extends Path2D

@export var loop := true
@export var SPEED := 1
@export var speed_scale := 1.0

@onready var path := $PathFollow2D
@onready var animation := $AnimationPlayer

func _ready() -> void:
	animation.play("move")
