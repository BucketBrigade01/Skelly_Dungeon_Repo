extends Node2D

var player
var init_level : LevelSelect
var current_level : LevelSelect 
var tween : Tween

func _ready() -> void:
	var level_selectors : Array = get_tree().get_nodes_in_group("LevelSelect")
	player = get_tree().get_nodes_in_group("SmallPlayer")[0]
	
	for level in level_selectors:
		if level.level_name == "Initial":
			init_level = level
	
	if init_level != null:
		player.position = init_level.position

	current_level = init_level

func _input(event):
	if tween and tween.is_running():
		return
	
	if event.is_action_pressed("right") and current_level.right_level != null:
		current_level = current_level.right_level
		tween_position()
	if event.is_action_pressed("left") and current_level.left_level != null:
		current_level = current_level.left_level
		tween_position()
	if event.is_action_pressed("down") and current_level.down_level != null:
		current_level = current_level.down_level
		tween_position()
	if event.is_action_pressed("up") and current_level.up_level != null:
		current_level = current_level.up_level
		tween_position()
	if event.is_action_pressed("jump") and current_level.level_path != null:
		current_level.load_level()

func tween_position() -> void:
	tween = get_tree().create_tween()
	tween.tween_property(player, "position",  current_level.position, 0.25).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
