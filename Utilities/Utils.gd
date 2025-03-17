extends Node

# This signal gets emitted everytime a var gets set 
signal update_world_stats(health, coin, breakable)

# Player Variables
var player_health : int = 3:
	get = get_health, set = set_health
var health_multiplier : int  = 3
var player_crouch_val : int = 0
var player_crouched : bool
var coin_count : int = 0:
	get = get_coin_count, set = set_coint_count
var player_spawnpoint : int = 0

# Bullet Upgrades
var breakable_upgrade := false:
	get = get_breakable, set = set_breakable
	
# Items
var has_key := false :
	get = get_key, set = set_key
	
# Textbox Variables
var textbox_reading : bool = false

# Resets the variables on restart
func reset() -> void:
	player_health = 3
	coin_count = 0
	has_key = false

# Keeps track of the player crouch value
func _process(_delta: float) -> void:
	player_crouch_val = clamp(player_crouch_val, 0, 20)

# Getters and Setters
func get_key() -> bool:
	return has_key
	
func set_key(value : bool) -> void:
	if value:
		has_key = true
	else: 
		has_key = false

func get_breakable() -> bool:
	return breakable_upgrade

func set_breakable(value) -> void:
	breakable_upgrade = value
	update_world_stats.emit(player_health, coin_count, breakable_upgrade)

func get_coin_count() -> int:
	return coin_count
	
func set_coint_count(amount) -> void:
	if amount == 0:
		coin_count = 0
		return
	coin_count += amount
	update_world_stats.emit(player_health, coin_count, breakable_upgrade)

func get_health() -> int:
	return player_health
	
func set_health(amount) -> void:
	player_health += amount
	player_health = clamp(player_health, 0, health_multiplier)
	update_world_stats.emit(player_health, coin_count, breakable_upgrade)
