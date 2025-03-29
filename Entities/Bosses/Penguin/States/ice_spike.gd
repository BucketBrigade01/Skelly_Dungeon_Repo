extends State

@export var penguin : Penguin
@export var animation : AnimatedSprite2D
@export var target_left : Marker2D
@export var targer_right : Marker2D

@onready var ice_spike = preload("res://Entities/Damagables/Ice_Spikes/ice_spike.tscn")

var ice_spike_instance_1 : Area2D
var ice_spike_instance_2 : Area2D

func spawn_icespikes() -> void:
	ice_spike_instance_1 = ice_spike.instantiate()
	ice_spike_instance_2 = ice_spike.instantiate()
	ice_spike_instance_1.global_position = target_left.position
	ice_spike_instance_2.global_position = targer_right.position
	penguin.add_child(ice_spike_instance_1)
	penguin.add_child(ice_spike_instance_2)

func enter():
	animation.play("ice_fall")
	penguin.current_state = "icespike"
	spawn_icespikes()
	print_debug("ice spike")
	
func exit():
	penguin.previous_state = "icespike"
	penguin.can_icespike = false
	penguin.get_icespike_timer()
	ice_spike_instance_1.queue_free()
	ice_spike_instance_2.queue_free()
	animation.stop()

func get_idle_timer() -> void:
	await get_tree().create_timer(2).timeout
	transition.emit("walk")
