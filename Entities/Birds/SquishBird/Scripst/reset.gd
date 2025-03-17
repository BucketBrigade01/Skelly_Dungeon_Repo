extends State
class_name SquishBirdReset

@export var animated_sprite : AnimatedSprite2D
@export var squish_bird : SquishBird

var player : CharacterBody2D
var dip_timer : float = 0.05


func on_physics_process(_delta : float) -> void:
	
	if squish_bird.player_on:
		squish_bird.velocity.y = 100
		get_dip_timer()
		
	else:
		squish_bird.velocity.y = -30 
		
	squish_bird.move_and_slide()
	if squish_bird.get_slide_collision_count() > 0:
		if squish_bird.is_on_ceiling_only() and squish_bird.get_slide_collision(0).get_collider().get_class() == "StaticBody2D":
			transition.emit("tilt")
func enter():
	animated_sprite.play("reset")
	$"../../FlapSound".play()
	
func exit():
	pass

func get_dip_timer() -> void:
	await get_tree().create_timer(dip_timer).timeout
	squish_bird.player_on = false


func _on_flap_sound_finished() -> void:
	get_flap_timer()
	
func get_flap_timer() -> void:
	await get_tree().create_timer(0.75).timeout
	$"../../FlapSound".play()
