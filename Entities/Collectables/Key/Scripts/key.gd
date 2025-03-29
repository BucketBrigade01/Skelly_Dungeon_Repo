class_name RegularKey extends Area2D

@export var world : Node2D

@onready var original_position = position.y
@onready var animation := $AnimatedSprite2D

enum States {
	SPAWNING,
	IDLE,
	SHINE,
	COLLECTED
}

var current_state : States
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
	animation.play("spawn")
	change_state(States.SPAWNING)
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Utils.has_key = true
		change_state(States.COLLECTED)
		animation.play("collect")

func change_state(new_state : States) -> void:
	current_state = new_state
	match current_state:
		States.SPAWNING:
			pass
		States.IDLE:
			get_shine_timer()
		States.SHINE:
			animation.play("shine")
		States.COLLECTED:
			$CollectedSound.play()

func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "spawn":
		change_state(States.IDLE)
	elif animation.animation == "shine":
		change_state(States.IDLE)
	elif animation.animation == "collect":
		queue_free()

func get_shine_timer() -> void:
	await get_tree().create_timer(1).timeout
	if not animation.animation == "collect":
		change_state(States.SHINE)
