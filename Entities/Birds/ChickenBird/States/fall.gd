extends State

@export var chicken : Chicken
@export var animation : AnimatedSprite2D
@export var ray1 : RayCast2D
@export var ray2 : RayCast2D
	
func on_physics_process(_delta : float):
	chicken.velocity.y += 10
	chicken.velocity.x = -50 * chicken.direction
	
	chicken.move_and_slide()
	
	if chicken.is_on_floor():
		transition.emit(chicken.prev_state)

func enter():
	chicken.cur_state = "fall"
	
func exit():
	chicken.prev_state = "fall"
