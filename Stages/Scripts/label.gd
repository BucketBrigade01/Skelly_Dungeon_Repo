extends Label

@export var world : Node2D

var fade_in : bool = false
var activate : bool = false

func _process(_delta: float) -> void:
	
	# Sets up the button fade in fade out loop	
	# Start on fade in
	if visible and not fade_in:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate:a", 1.0, 0.1)
		tween.connect("finished", on_tween_finished_fadein)
		fade_in = true

# Fade out tween	
func on_tween_finished_fadein():
	if get_tree() != null:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate:a", 1.0, 1)
		tween.connect("finished", on_tween_finished_fadeout)

# Fade in tween
func on_tween_finished_fadeout():
	if get_tree() != null:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 1)
		tween.connect("finished", on_tween_finished_fadein)
