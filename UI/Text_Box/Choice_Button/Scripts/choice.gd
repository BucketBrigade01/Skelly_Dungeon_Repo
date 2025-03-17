class_name ChoiceOption extends Label

signal choice_selected(choice_index)

var choice_index : int 

var is_selected : bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and is_selected:
		choice_selected.emit(choice_index)
