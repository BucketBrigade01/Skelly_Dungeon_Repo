extends CanvasLayer
class_name CoinBox

@export var player_stats : PlayerStats

func _process(delta: float) -> void:
	$CoinCount.text = str(Utils.coin_count)
