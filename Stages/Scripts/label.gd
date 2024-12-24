extends Label

@export var world : Node2D

var fade_in : bool = false

func _process(_delta: float) -> void:
	if world.activate_textbox:
		visible = false
		
	if world.interact_button and not fade_in:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate:a", 1.0, 0.1)
		tween.connect("finished", on_tween_finished_fadein)
		fade_in = true
		
func on_tween_finished_fadein():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1)
	tween.connect("finished", on_tween_finished_fadeout)

func on_tween_finished_fadeout():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1)
	tween.connect("finished", on_tween_finished_fadein)
