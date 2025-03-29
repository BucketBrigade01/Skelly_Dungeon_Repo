extends State
class_name BirdIdle

@export var bird : LazerBird
@export var animation_sprite : AnimatedSprite2D

var difference : Vector2
var on_screen : bool = false

func on_process(_delta : float):
	if !bird.on_screen:
		return
	
	difference = bird.target.global_position - bird.position
	if difference.length() < 70:
		transition.emit("hatch")
	
func enter():
	animation_sprite.play("idle")
	
func exit():
	pass


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_screen = true
