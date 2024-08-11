extends CanvasLayer

signal energy_animation

var player_crouched : bool
var current_animation : String
var current_frame : int

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	animated_sprite.play("empty")

# NOTE TRANSFORM THIS INTO STATE MACHINE 
func _process(delta):
	# This section is for when the bar is charging up
	if player_crouched:
		if animated_sprite.animation == "empty":
			animated_sprite.play("charge")
		if animated_sprite.frame == 15 and animated_sprite.animation == "charge":
			animated_sprite.play("full")
		if animated_sprite.animation == "charge" and animated_sprite.frame < 15:
			animated_sprite.play("charge")
		if animated_sprite.animation == "decharge":
			animated_sprite.play_backwards("decharge")
		if animated_sprite.animation == "decharge" and animated_sprite.frame == 0:
			animated_sprite.play("full")
	# This section is for when the bar is decharging 
	else:
		if animated_sprite.animation == "full":
			animated_sprite.play("decharge")
		if animated_sprite.animation == "decharge" and animated_sprite.frame == 16:
			animated_sprite.play("empty")
		if animated_sprite.animation == "decharge" and animated_sprite.frame < 15:
			animated_sprite.play("decharge")
		if animated_sprite.animation == "charge":
			animated_sprite.play_backwards("charge")
		if animated_sprite.animation == "charge" and animated_sprite.frame == 0:
			animated_sprite.play("empty")
	
	# Set variables to allow for boost jump
	current_frame = animated_sprite.frame	
	current_animation = animated_sprite.animation
	energy_animation.emit(str(current_frame), current_animation)
	
func _on_player_player_status(status : String):
	# Crouched when the palyer emits a crouched state, uncrowched for the opposite
	if status == "crouched":
		player_crouched = true
	elif status == "uncrouched":
		player_crouched = false
