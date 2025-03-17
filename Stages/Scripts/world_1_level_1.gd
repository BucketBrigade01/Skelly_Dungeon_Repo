extends Node2D

signal objective_complete_signal()

@export var jason : JSON

@onready var text_box := $UI/TextBox
@onready var path := $Path2D
@onready var button := $UI/button
@onready var state = {
	"coin_count" : Utils.coin_count,
	"breakable_status" : Utils.breakable_upgrade
}

var interact_button : bool = false
var text_box_finished : bool = false
var objective_complete : bool = false
var text_box_running : bool = false

const level_name := "level 1"

func _ready() -> void:
	Utils.connect("update_world_stats", update_stats)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and button.visible and !is_textbox_running() and path.path_complete:
		activate_textbox()

func is_textbox_running() -> bool:
	return text_box.textbox_running

func activate_button() -> void:
	if !is_textbox_running():
		button.visible = true

func activate_textbox() -> void:
	text_box.show_textbox()
	button.visible = false
	($EzDialogue as EzDialogue).start_dialogue(jason, state)


func _on_ez_dialogue_dialogue_generated(response: DialogueResponse) -> void:
	text_box.remove_text()
	text_box.add_text(response.text)
	if response.choices.is_empty():
		text_box.waiting_for_next_action = true
	else:
		for choice in response.choices:
			text_box.add_choice(choice)


func _on_ez_dialogue_end_of_dialogue_reached() -> void:
	text_box.hide_textbox()
	text_box_finished = true
	if !objective_complete and !button.visible:
		activate_button()

func _on_ez_dialogue_custom_signal_received(value: Variant) -> void:
	print_debug(value)
	if value == "true":
		objective_complete = true
		objective_complete_signal.emit()

func update_stats(health, coin, breakable) -> void:
	state['coin_count'] = coin
	state["breakable_status"] = breakable
