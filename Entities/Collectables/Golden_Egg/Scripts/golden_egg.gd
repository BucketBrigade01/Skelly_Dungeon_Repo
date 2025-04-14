class_name GoldenEgg extends Area2D

@export var target : Marker2D 
@export var SPEED : int = 100

@onready var init_position_y : float = global_position.y
@onready var animation := $AnimatedSprite2D

var time : float = 0.0
var freq : float = 1
var amp : float = 5
var tween_duration : float = 2.0

func _ready() -> void:
	Utils.connect("update_boss_health", update)
	set_process(false)

func _process(delta) -> void:
	time += delta
	
	position.y = init_position_y + sin(time * freq) * amp

func transition() -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position:y", target.global_position.y, tween_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.finished.connect(on_tween_finished)

func on_tween_finished() -> void:
	init_position_y = global_position.y
	set_process(true)

func update(health) -> void:
	if health == 0:
		get_golden_egg_timer()

func get_golden_egg_timer() -> void:
	await get_tree().create_timer(2.0).timeout
	transition()

func _on_body_entered(body):
	if body is Player:
		$CollectSound.play()
		$GoldenSound.play()
		animation.play("collected")

func _on_animated_sprite_2d_animation_finished():
	if animation.animation == "collected":
		queue_free()
