extends CanvasLayer

@export var world : Node2D
@export var ez_dialogue : EzDialogue

# Textbox Variables
@onready var dialogue_text := $TextBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/text
@onready var start_symbol := $TextBoxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol := $TextBoxContainer/MarginContainer/HBoxContainer/End
@onready var tween : Tween

# Dialogue Containers
@onready var dialogue_container := $TextBoxContainer/MarginContainer/HBoxContainer/VBoxContainer
@onready var choice_container := $TextBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer
@onready var textbox_container := $TextBoxContainer

# Choice Variables
@onready var choice_option_scene = preload("res://UI/Text_Box/Choice_Button/choice.tscn")

enum States {
	READY,
	READING, 
	FINISHED
}

var choice_options : Array[ChoiceOption] = []
var current_choice_index : int = 0
var waiting_for_next_action : bool = false
var textbox_running : bool = false
var current_state := States.READY

const READ_RATE := 0.05

func _ready() -> void:
	textbox_container.visible = false
	end_symbol.visible = false
	
func _input(event: InputEvent) -> void:
	if textbox_container.visible:
		if !choice_options.is_empty():
			if event.is_action_pressed("right") and current_choice_index < choice_options.size() - 1:
				next_choice(choice_options[current_choice_index], choice_options[current_choice_index + 1])
			if event.is_action_pressed("left") and !current_choice_index < 1:
				previous_choice(choice_options[current_choice_index], choice_options[current_choice_index - 1])
		else:
			if event.is_action_pressed("interact") and current_state == States.READING:
				dialogue_text.visible_ratio = 1.0
				tween.kill()
				change_state(States.FINISHED)
			elif event.is_action_pressed("interact") and current_state == States.FINISHED: 
				player_next_action()

	
func add_text(text : String) -> void:
	dialogue_text.text = text
	change_state(States.READING)
	tween = get_tree().create_tween()
	tween.tween_property(dialogue_text, "visible_characters", len(text), len(text) * READ_RATE).from(0).finished
	tween.connect("finished", on_tween_finished)
	
func remove_text() -> void:
	dialogue_text.text = ""
	for choice in choice_options:
		choice_container.remove_child(choice)
	choice_options = []

func add_choice(choice_text : String) -> void:
	var choice_instance = choice_option_scene.instantiate() as ChoiceOption
	choice_instance.choice_index = choice_options.size()
	choice_options.push_back(choice_instance)
	choice_instance.choice_selected.connect(_on_choice_selected)
	choice_instance.text = choice_text
	choice_instance.visible = false
	
	if choice_options.size() == 1:
		choice_instance.text = choice_instance.text + "<"
		
	choice_container.add_child(choice_instance)
	
func next_choice(previous_choice : ChoiceOption, current_choice : ChoiceOption) -> void:
	previous_choice.text = previous_choice.text.left(previous_choice.text.length() - 1)
	current_choice.text = current_choice.text + "<"
	current_choice.is_selected = true
	previous_choice.is_selected = false
	current_choice_index += 1

func previous_choice(previous_choice : ChoiceOption, current_choice : ChoiceOption) -> void:
	previous_choice.text = previous_choice.text.left(previous_choice.text.length() - 1)
	current_choice.text = current_choice.text + "<"
	current_choice.is_selected = true
	previous_choice.is_selected = false
	current_choice_index -= 1

func show_textbox() -> void:
	textbox_running = true
	textbox_container.show()

func hide_textbox() -> void:
	textbox_running = false
	textbox_container.hide()

func player_next_action() -> void:
	ez_dialogue.next(0)

func _on_choice_selected(choice_index : int) -> void:
	ez_dialogue.next(choice_index)

func on_tween_finished() -> void:
	change_state(States.FINISHED)

func show_choices() -> void:
	for choice in choice_options:
		choice.visible = true
	
func change_state(new_state) -> void:
	current_state = new_state
	match current_state:
		States.READY:
			pass
		States.READING:
			end_symbol.visible = false
		States.FINISHED:
			end_symbol.visible = true
			show_choices()
