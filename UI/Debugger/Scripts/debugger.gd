extends CanvasLayer

@export var player : Player

@onready var current_state := $CenterContainer/PanelContainer/VBoxContainer/CurrentState
@onready var previous_state := $CenterContainer/PanelContainer/VBoxContainer/PreviousState

func _ready() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug") and !visible:
		visible = true
	elif event.is_action_pressed("debug") and visible:
		visible = false

func _process(_delta: float) -> void:
	current_state.text = "CURRENT STATE: " + player.current_state
	previous_state.text = "PREVIOUS STATE: " + player.previous_state
