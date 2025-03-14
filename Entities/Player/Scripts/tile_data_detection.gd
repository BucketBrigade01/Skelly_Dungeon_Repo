class_name TileDataDetection extends Node2D

@export var player : Player

@onready var left_ray := $LeftTileRay
@onready var right_ray := $RightTileRay

var current_tilemap : TileMap
var tile_data : int
var tile_type : String 

enum TileType {
	WALLJUMP = 1,
	WALL = 2,
	SPIKES = 3
}


func match_data():
	match tile_data:
		TileType.WALLJUMP:
			tile_type = "walljump"
		TileType.WALL:
			tile_type = "wall"
		TileType.SPIKES:
			tile_type = "spikes"
		_:
			tile_type = "none"

func _physics_process(delta: float) -> void:
	if right_ray.is_colliding():
		var target = right_ray.get_collider()
		var target_rid = right_ray.get_collider_rid()
		if target is TileMap:
			process_tile_map(target, target_rid)
	elif left_ray.is_colliding():
		var target = left_ray.get_collider()
		var target_rid = left_ray.get_collider_rid()
		if target is TileMap:
			process_tile_map(target, target_rid)
	else:
		tile_type = "none"
			
func process_tile_map(body : Node2D, body_rid : RID):
	current_tilemap = body
	var current_tilemap_cords = current_tilemap.get_coords_for_body_rid(body_rid)
	var current_tile_cell_data = current_tilemap.get_cell_tile_data(1, current_tilemap_cords)

	var tile_layers : Array = []
	if current_tile_cell_data != null:
		for index in 3:
			if current_tile_cell_data.get_custom_data_by_layer_id(index) != 0:
				tile_layers.push_front(current_tile_cell_data.get_custom_data_by_layer_id(index))
			else:
				tile_layers.push_back(current_tile_cell_data.get_custom_data_by_layer_id(index))
			
		tile_data = tile_layers[0]
		match_data()
		check_damagables()
	
func check_damagables() -> void:
	if tile_type == "spikes":
		player.is_dying_spikes = true
		player.is_dying = true

func _on_hit_box_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is TileMap:
		process_tile_map(body, body_rid)
