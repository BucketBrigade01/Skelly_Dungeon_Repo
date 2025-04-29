@tool
extends Node2D
class_name LevelSelect

@export var level_name : String
@export var left_level : LevelSelect
@export var right_level : LevelSelect
@export var up_level : LevelSelect
@export var down_level : LevelSelect
@export var level_path : String

var level : PackedScene

func _ready() -> void:
	if level_name != null:
		$Label.text = level_name

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		$Label.text = level_name

func load_level() -> void:
	get_tree().change_scene_to_file(level_path)
