extends Node2D
	
@onready var cloud : GPUParticles2D = $GPUParticles2D
@onready var small_particle : GPUParticles2D = $GPUParticles2D2

var direction : int = 1

func _ready() -> void:
	cloud.emitting = true
	small_particle.rotation_degrees = 180.0 if direction == -1 else 0.0
	small_particle.emitting = true
	$BirdDead.play()
