extends CanvasLayer

@export var text_box : MarginContainer
@export var start : Label
@export var text_body : Label
@export var end : Label
@export var world : Node2D

enum States {
	READY,
	READING,
	FINISHED
} 

var current_state = States.READY 
var tween : Tween
var text_queuu : Array = []

func _ready() -> void:
	hide_textbox()
	queue_twxt("Hello Skelly, we will get to know eachother soon enough")
	queue_twxt("Get me the 6 Golden Eggs and I will return you back home")
	queue_twxt("Now go, SCRAM!")

func _process(_delta: float) -> void:
	if world.activate_textbox == true:
		text_box.visible = true
		Utils.textbox_reading = true
	
	if text_box.visible:
		match current_state:
			States.READY:
				end.text = ""
				if !text_queuu.is_empty():
					displau_text()
				else:
					hide_textbox()
					Utils.textbox_reading = false
					world.text_box_finished = true
			States.READING:
				if GameInput.interact_input():
					tween.stop()
					text_body.visible_ratio = 1
					end.text = "v"
					change_state(States.FINISHED)
			States.FINISHED:
				if GameInput.interact_input():
					change_state(States.READY)
	
func hide_textbox() -> void:
	start.text = ""
	text_body.text = ""
	end.text = ""
	text_box.hide()

func queue_twxt(next_text : String) -> void:
	text_queuu.push_back(next_text)

func show_textbox() -> void:
	text_box.show()
	start.text = "*"
	
func displau_text() -> void:
	text_body.text = text_queuu.pop_front()
	text_body.visible_ratio = 0
	change_state(States.READING)
	show_textbox()
	tween = get_tree().create_tween()
	tween.tween_property(text_body, "visible_ratio", 1.0, 3).set_trans(Tween.TRANS_LINEAR)
	tween.connect("finished", on_tween_finished)
	
func on_tween_finished() -> void:
	end.text = "v"
	change_state(States.FINISHED)

func change_state(next_state) -> void:
	current_state = next_state
	match current_state:
		States.READY:
			pass
		States.READING:
			pass
		States.FINISHED:
			pass
