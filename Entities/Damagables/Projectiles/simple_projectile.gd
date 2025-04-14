extends Area2D

var direction : float = 1.0
var SPEED : int = 300
var in_air : bool = true
var in_air_default := "in_air"
var hit_wall_default := "wall_hit"
var in_air_breakable := "in_air_breakable"
var hit_wall_breakable := "wall_hit_breakable"
var current_animation_air = hit_wall_default
var curremt_animation_wall = hit_wall_default

@onready var animated_sprite := $AnimatedSprite2D

var current_tilemap : TileMap
var tile_data : int
var tile_type : String 

enum TileType {
	WALLJUMP = 1,
	WALL = 2,
	SPIKES = 3,
	BREAKABLE_BOTTOM = 4,
	BREAKABLE_TOP = 5,
	BREAKABLE_TOP_LEFT = 6,
	BREAKABLE_BOTTOM_LEFT = 7
}


func match_data():
	match tile_data:
		TileType.WALLJUMP:
			tile_type = "walljump"
		TileType.WALL:
			tile_type = "wall"
		TileType.SPIKES:
			tile_type = "spikes"
		TileType.BREAKABLE_BOTTOM:
			tile_type = "breakable_bottom"
		TileType.BREAKABLE_TOP:
			tile_type = "breakable_top"
		TileType.BREAKABLE_BOTTOM_LEFT:
			tile_type = "breakable_bottom_left"
		TileType.BREAKABLE_TOP_LEFT:
			tile_type = "breakable_top_left"
		_:
			tile_type = "none"
		

func _ready() -> void:
	if Utils.breakable_upgrade:
		animated_sprite.play("in_air_breakable")
		curremt_animation_wall = hit_wall_breakable
		
func _process(delta):
	if in_air:
		position += transform.x * SPEED * direction * delta
	else:
		position += transform.x * 0
	
func flip_projectile():
	direction = -1
	animated_sprite.flip_h = true

func process_tile_map(body : Node2D, body_rid : RID):
	current_tilemap = body
	var current_tilemap_cords = current_tilemap.get_coords_for_body_rid(body_rid)
	var current_tile_cell_data = current_tilemap.get_cell_tile_data(1, current_tilemap_cords)

	var tile_layers : Array = []
	for index in 7:
		if current_tile_cell_data.get_custom_data_by_layer_id(index) != 0:
			tile_layers.push_front(current_tile_cell_data.get_custom_data_by_layer_id(index))
		else:
			tile_layers.push_back(current_tile_cell_data.get_custom_data_by_layer_id(index))
			
	tile_data = tile_layers[0]
	match_data()
	if Utils.breakable_upgrade:
		check_breakable(current_tilemap_cords, current_tilemap)
	
func check_breakable(cords, tilemap) -> void:
	
	if tile_type == "breakable_bottom":
		tilemap.erase_cell(1, cords)
		var tile_right = tilemap.get_neighbor_cell(cords, 0)
		var tile_bottom_right = tilemap.get_neighbor_cell(cords, 3)
		var tile_bottom = tilemap.get_neighbor_cell(cords, 4)
		tilemap.set_cell(2, tile_right, 1, Vector2i(14,0))
		tilemap.set_cell(1, tile_bottom_right, 1, Vector2i(2,0))
		tilemap.set_cell(1, tile_bottom, 1, Vector2i(0,0))
		$WallBreakSound.play()
	if tile_type == "breakable_top":
		tilemap.erase_cell(1, cords)
		var tile_right = tilemap.get_neighbor_cell(cords, 0)
		var tile_top_right = tilemap.get_neighbor_cell(cords, 15)
		var tile_top = tilemap.get_neighbor_cell(cords, 12)
		tilemap.set_cell(2, tile_right, 1, Vector2i(14,0))
		tilemap.set_cell(1, tile_top_right, 1, Vector2i(1,4))
		tilemap.set_cell(1, tile_top, 1, Vector2i(0,4))
		$WallBreakSound.play()
	if tile_type == "breakable_bottom_left":
		tilemap.erase_cell(1, cords)
		var tile_left = tilemap.get_neighbor_cell(cords, 8)
		var tile_bottom_left = tilemap.get_neighbor_cell(cords, 7)
		var tile_bottom = tilemap.get_neighbor_cell(cords, 4)
		tilemap.set_cell(2, tile_left, 1, Vector2i(14,0))
		tilemap.set_cell(1, tile_bottom_left, 1, Vector2i(2,0))
		tilemap.set_cell(1, tile_bottom, 1, Vector2i(4,0))
		$WallBreakSound.play()
	if tile_type == "breakable_top_left":
		tilemap.erase_cell(1, cords)
		var tile_left = tilemap.get_neighbor_cell(cords, 8)
		var tile_top_left = tilemap.get_neighbor_cell(cords, 11)
		var tile_top = tilemap.get_neighbor_cell(cords, 12)
		tilemap.set_cell(2, tile_left, 1, Vector2i(14,0))
		tilemap.set_cell(1, tile_top_left, 1, Vector2i(3,4))
		tilemap.set_cell(1, tile_top, 1, Vector2i(4,4))
		$WallBreakSound.play()
		
func _on_animated_sprite_2d_animation_finished():
	queue_free()


func _on_area_entered(area):
	if area.is_in_group("LazerBird"):
		in_air = false
		$CPUParticles2D.emitting = false
		animated_sprite.play(curremt_animation_wall)
		$CollisionShape2D.set_deferred("disabled", true)
	if area.is_in_group("Penguin"):
		in_air = false
		$CPUParticles2D.emitting = false
		animated_sprite.play(curremt_animation_wall)
		$CollisionShape2D.set_deferred("disabled", true)
	if area.is_in_group("UpDownBird"):
		in_air = false
		$CPUParticles2D.emitting = false
		animated_sprite.play(curremt_animation_wall)
		$CollisionShape2D.set_deferred("disabled", true)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMap:
		process_tile_map(body, body_rid)
		in_air = false
		$CPUParticles2D.emitting = false
		#$WorldEnvironment.environment.glow_enabled = false
		animated_sprite.play(curremt_animation_wall)
		$BulletBreakSound.play()
