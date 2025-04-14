class_name FollowKey extends Area2D

@export var follow_speed: float = 5.0  # Adjust for faster/slower following
@export var max_distance: float = 40.0  # Maximum distance before speeding up catch-up
@export var hover_amplitude: float = 5.0  # How high/low it hovers
@export var hover_frequency: float = 2.0  # How fast it bobs up and down

@onready var original_position = position.y
@onready var animation := $AnimatedSprite2D
#@onready var remote_path := $RemoteTransform2D

var time: float = 0.0
var target_position: Vector2
var offset: Vector2 = Vector2(-20, 0)  # Default offset behind player (adjust as needed)
var target_node : Player 
var last_direction : float = 1.0

enum States {
	SPAWNING,
	IDLE,
	SHINE,
	COLLECTED
}

func _ready() -> void:
	if get_parent().name == "World_1_Level_3" or get_parent().name == "World1_Level1":
		target_node  = get_tree().get_nodes_in_group("Player")[0]
	Utils.connect("update_key", update_stats)
	
func _process(delta: float) -> void:
	if target_node:
		time += delta
		var hover_offset = sin(time * hover_frequency) * hover_amplitude
		
		var direction = GameInput.movment_input()
		
		if direction != 0.0:
			last_direction = direction
		
		target_position = target_node.global_position + (offset * direction)
		target_position.y += hover_offset
		
		var distance = global_position.distance_to(target_position)
		
		var current_speed = follow_speed
		if distance > max_distance:
			current_speed = follow_speed * (distance / max_distance)
		
		var min_follow : Vector2
		if last_direction == -1.0:
			min_follow = Vector2(10,0)
		elif last_direction == 1.0:
			min_follow = Vector2(-10,0)
			
		if direction != 0.0:
			global_position = global_position.lerp(target_position, current_speed * delta)
		else:
			global_position = global_position.lerp(target_position + min_follow, current_speed * delta)

func update_stats(key):
	if !key and visible:
		animation.play("collect")

func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "collect":
		queue_free()
