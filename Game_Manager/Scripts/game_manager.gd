extends Node
class_name GameManager

@export var world_2d : Node2D
@export var world_gui : Control

var current_2d_sceme 
var current_gui_scene 

func _ready():
	GlobalManager.game_manager = self
