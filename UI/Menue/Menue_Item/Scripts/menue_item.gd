@tool
extends Control
class_name MenueItem

@export var item_name : String

@onready var label : Label = $MarginContainer/Label

var selected : bool = false
var tween : Tween

func _ready() -> void:
	label.text = item_name

func _process(delta : float) -> void:
	if Engine.is_editor_hint():
		label.text = item_name
	
	if selected:
		tween = get_tree().create_tween()
		tween.tween_property(label, "theme_override_colors/font_color", Color(0,1,1,1), 0.1)
	else:
		tween = get_tree().create_tween()
		tween.tween_property(label, "theme_override_colors/font_color", Color(1,1,1,1), 0.1)
