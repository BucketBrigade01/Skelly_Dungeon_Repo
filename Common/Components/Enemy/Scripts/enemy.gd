extends CharacterBody2D
class_name Enemy

@export var stats : EnemyStats
@export var animation_player : AnimationPlayer
@export var animated_sprite : AnimatedSprite2D
@export var body_collider : CollisionShape2D
@export var hurt_box_collider : HurtBox
@export var state_machine : StateMachine

@onready var target : Player
@onready var death_particle : PackedScene = preload("res://Entities/Particles/Death_Particle/death_particle.tscn")

var dead : bool
var particle_direction : int = 1:
	set = set_direction

func _set_target() -> void:
	target = get_tree().get_nodes_in_group("Player")[0]
	
func take_damage() -> void:
	stats.take_damage(1)
	animation_player.play("hit")
	if stats.get_health() == 0:
		kill()

func set_direction(value):
	particle_direction = value
	
func kill() -> void:
	body_collider.set_deferred("disabled", true)
	hurt_box_collider.disable_collision()
	set_physics_process(false)
	dead = true
	var death_particle_inst = death_particle.instantiate()
	death_particle_inst.global_position = self.global_position
	death_particle_inst.direction = particle_direction
	get_parent().add_child(death_particle_inst)
	if state_machine:
		state_machine.queue_free()
	queue_free()
		
