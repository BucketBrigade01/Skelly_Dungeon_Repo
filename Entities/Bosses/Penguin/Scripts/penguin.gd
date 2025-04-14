class_name Penguin extends CharacterBody2D

@onready var ice_marker_right := $IceSpikeMarkerRight
@onready var ice_marker_left := $IceSpikeMarkerLeft
@onready var detection_collider : CollisionShape2D = $DetectionZone/CollisionShape2D
@onready var hit_collider : CollisionShape2D = $HitZone/CollisionShape2D
@onready var belly_collider : CollisionShape2D = $BellyZone/CollisionShape2D
@onready var damage_collider : CollisionShape2D = $DamageZone/CollisionShape2D
@onready var self_collider : CollisionShape2D = $CollisionShape2D

var previous_state : String
var current_state : String
var target : Player
var can_punch : bool = false
var can_icefall : bool = false
var can_icespike : bool = false
var attacks : Array[bool]
var dying : bool = false

func _ready() -> void:
	target = get_tree().get_nodes_in_group("Player")[0]
	get_icefall_timer()
	$AnimatedSprite2D.material.set_shader_parameter("enable", false)
	Utils.connect("update_boss_health", update)
	
func get_icefall_timer() -> void:
	if !dying:
		await get_tree().create_timer(10).timeout
		can_icefall = true

func _on_hit_zone_area_entered(area):
	if area.is_in_group("Bullet"):
		Utils.set_boss_health(-2)
		$AnimationPlayer.play("hit")

func update(health):
	if health == 0:
		dying = true	
		$AnimationPlayer.stop()
		self_collider.set_deferred("disabled", true)
		belly_collider.set_deferred("disabled", true)
		hit_collider.set_deferred("disabled", true)
		damage_collider.set_deferred("disabled", true)
		detection_collider.set_deferred("disabled", true)
		
func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "die":
		$StateMachine.queue_free()
		queue_free()
		
