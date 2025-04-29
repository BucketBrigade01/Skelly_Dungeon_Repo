extends Node2D

@export var start : Label
@export var end : Label
@export var start_arrow : Label
@export var end_arrow : Label

enum States {
	START, 
	SELECT, 
	FINISHED
}

var curremt_state : States = States.START

func _ready() -> void:
	hide_arrows()

func _process(_delta: float) -> void:
	match curremt_state:
		States.START:
			if GameInput.selection_input() == 1:
				start_arrow.visible = true
				start_flash()
				change_state(States.SELECT)
			if GameInput.selection_input() == -1:
				end_arrow.visible = true
				end_flash()
				change_state(States.SELECT)
				
		States.SELECT:
			if GameInput.jump_input() and start_arrow.visible:
				get_tree().call_deferred("change_scene_to_file", "res://Stages/overworld.tscn")
			if GameInput.jump_input() and end_arrow.visible:
				get_tree().quit()
			if GameInput.selection_input() == 1:
				start_arrow.visible = true
				end_arrow.visible = false
				start_flash()
			if GameInput.selection_input() == -1:
				end_arrow.visible = true
				start_arrow.visible = false
				end_flash()
				
		States.FINISHED:
			pass

func start_flash() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(start, "theme_override_colors/font_color", Color.GOLDENROD, 0.3)
	tween.tween_property(start, "theme_override_colors/font_color", Color(0.675, 0.196, 0.196, 1), 0.3)

func end_flash() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(end, "theme_override_colors/font_color", Color.GOLDENROD, 0.3)
	tween.tween_property(end, "theme_override_colors/font_color", Color(0.675, 0.196, 0.196, 1), 0.3)

func hide_arrows() -> void:
	start_arrow.visible = false
	end_arrow.visible = false

func change_state(next_state) -> void:
	curremt_state = next_state
