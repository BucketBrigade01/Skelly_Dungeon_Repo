class_name Penguin extends CharacterBody2D

@onready var ice_marker_right := $IceSpikeMarkerRight
@onready var ice_marker_left := $IceSpikeMarkerLeft

var previous_state : String
var current_state : String
var target : Player
var can_punch : bool = false
var can_icefall : bool = false
var can_icespike : bool = false
var attacks : Array[bool]

func _ready() -> void:
	target = get_tree().get_nodes_in_group("Player")[0]
	get_icefall_timer()

func get_icefall_timer() -> void:
	await get_tree().create_timer(10).timeout
	can_icefall = true
