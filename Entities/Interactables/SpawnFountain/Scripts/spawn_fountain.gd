extends StaticBody2D

@export var detection_box : DetectionBox
@export var animated_sprite : AnimatedSprite2D
@export var water_particles : GPUParticles2D
@export var magic_particles : GPUParticles2D

var active : bool = false

func activate() -> void:
	if !active:
		active = true
		animated_sprite.play("activate")

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "activate":
		animated_sprite.play("active")

func _on_animated_sprite_2d_animation_changed():
	if animated_sprite.animation == "active":
		water_particles.emitting = true
		magic_particles.emitting = true
