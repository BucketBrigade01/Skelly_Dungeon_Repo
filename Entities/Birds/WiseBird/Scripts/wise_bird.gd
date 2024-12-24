extends CharacterBody2D

@export var path : PathFollow2D
@export var animation_sprite : AnimatedSprite2D
@export var scene : Node2D

func _physics_process(_delta: float) -> void:
	if scene.text_box_finished:
		velocity.y = -40 	
	move_and_slide()
	
func _process(_delta: float) -> void:
	if int(path.progress) == 176:
		animation_sprite.play("idle")
		
