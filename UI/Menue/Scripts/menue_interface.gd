extends CanvasLayer

@export var init_item : MenueItem

var menue_items : Array
var item_indx : int 
var current_item : MenueItem

func _ready() -> void:
	visible = false
	init_item.selected = true
	menue_items = get_tree().get_nodes_in_group("MenueItem")
	current_item = init_item
	
func _input(event) -> void:
	if event.is_action_pressed("start") and visible == false: 
		visible = true
	elif event.is_action_pressed("start") and visible == true:
		visible = false
		item_indx = 0
	elif  event.is_action("interact") and visible:
		if item_indx == 0:
			get_tree().change_scene_to_file("res://Stages/overworld.tscn")
		if item_indx == 1:
			get_tree().quit()
	
	if visible:
		if event.is_action_pressed("down"):
			current_item.selected = false
			item_indx += 1
			item_indx = clamp(item_indx, 0, menue_items.size() - 1)
			current_item = menue_items[item_indx]
			current_item.selected = true
		elif event.is_action_pressed("up"):
			current_item.selected = false
			item_indx -= 1
			item_indx = clamp(item_indx, 0, menue_items.size() - 1)
			current_item = menue_items[item_indx]
			current_item.selected = true
