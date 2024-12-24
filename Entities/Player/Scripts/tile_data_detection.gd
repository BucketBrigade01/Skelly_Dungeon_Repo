extends Area2D
class_name TileDataDetection

var current_tilemap : TileMap
var tile_data : int
var tile_type : String

enum TileType {
	WALLJUMP = 1,
	WALL = 2,
}


func match_data():
	match tile_data:
		TileType.WALLJUMP:
			tile_type = "walljump"
		TileType.WALL:
			tile_type = "wall"
		_:
			tile_type = "none"
	
	
func process_tile_map(body : Node2D, body_rid : RID):
	current_tilemap = body
	var current_tilemap_cords = current_tilemap.get_coords_for_body_rid(body_rid)
	var current_tile_cell_data = current_tilemap.get_cell_tile_data(1, current_tilemap_cords)
	
	var tile_layers : Array = []
	for index in 2:
		if current_tile_cell_data.get_custom_data_by_layer_id(index) != 0:
			tile_layers.push_front(current_tile_cell_data.get_custom_data_by_layer_id(index))
		else:
			tile_layers.push_back(current_tile_cell_data.get_custom_data_by_layer_id(index))
			
	tile_data = tile_layers[0]
	match_data()
	
	
func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is TileMap:
		process_tile_map(body, body_rid)
