extends Area2D

@onready var animation := $AnimatedSprite2D
@export var door_barrier : CollisionShape2D

var player_entered := false
var opened := false

func _ready() -> void:
	animation.play("default")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_entered and Utils.has_key and !opened:
		animation.play("opening")
		$DoorOpenSound.play()
		$KeySound.play()
		opened = true
		Utils.set_key(false)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered = true

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_entered = false

func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "opening":
		animation.play("opened")
		door_barrier.set_deferred("disabled", true)


func _on_key_sound_finished() -> void:
	$LockFallSound.play()

func _on_door_open_sound_finished() -> void:
	if animation.animation == "opening":
		$DoorOpenSound.play()
	elif animation.animation == "opened":
		$DoorOpenSound.stop()
