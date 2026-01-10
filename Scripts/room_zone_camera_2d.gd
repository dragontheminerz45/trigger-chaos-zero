extends Camera2D

var overlapping_zones: Array = []
var active_zone: Area2D

var player_node = CharacterBody2D

var follow_player: bool = false

var desired_offset: Vector2

var min_offset = -100
var max_offset = 100

var TransitionTween: Tween
var TransitionZoomTween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("RoomZoneCamera")
	player_node = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	if !player_node:
		player_node = get_tree().get_first_node_in_group("player")
		return
	
	if overlapping_zones.is_empty() or (overlapping_zones.size() == 1 and active_zone == overlapping_zones[0]):
		return
	
	var new_zone = get_closest_zone()
	if new_zone != active_zone:
		active_zone = new_zone
		apply_zone_settings()

func _physics_process(_delta: float) -> void:
	if follow_player and player_node:
		desired_offset = (get_global_mouse_position() - position) * 0.5
		desired_offset.x = clamp(desired_offset.x, min_offset, max_offset)
		desired_offset.y = clamp(desired_offset.y, min_offset/2.0, max_offset/2.0)
		
		global_position = get_parent().get_node("Player").global_position + desired_offset

func get_closest_zone() -> Area2D:
	var closest_zone: Area2D = null
	var closest_dist: float = INF
	var player_pos: Vector2 = player_node.global_position
	
	for zone in overlapping_zones:
		var zone_shape: CollisionShape2D = zone.collisionShape
		var col_margin: float = 0.1
		var zone_shape_pos: Vector2 = zone_shape.global_position
		var zone_shape_extents: Vector2 = zone_shape.shape.extents
		var shape_sides: Array[Vector2] = [
			Vector2(zone_shape_pos.x - zone_shape_extents.x + col_margin, player_pos.y), # left side
			Vector2(zone_shape_pos.x + zone_shape_extents.x - col_margin, player_pos.y), # right side
			Vector2(player_pos.x, zone_shape_pos.y - zone_shape_extents.y + col_margin), # top side
			Vector2(player_pos.x, zone_shape_pos.y + zone_shape_extents.y - col_margin)  # bottom side
		]
		var closest_dist_shapeside: float = INF
		for col_side in shape_sides:
			var col_dist: float = player_pos.distance_to(col_side)
			if col_dist < closest_dist_shapeside:
				closest_dist_shapeside = col_dist
		
		if closest_dist_shapeside < closest_dist:
			closest_dist = closest_dist_shapeside
			closest_zone = zone
	
	return closest_zone

func apply_zone_settings():
	if TransitionZoomTween:
		TransitionZoomTween.kill()
	TransitionZoomTween = create_tween()
	TransitionZoomTween.tween_property(self, "zoom", active_zone.zoom, 0.5).set_trans(Tween.TRANS_SINE)
	#zoom = active_zone.zoom
	
	follow_player = active_zone.follow_player
	if !active_zone.follow_player:
		if TransitionTween:
			TransitionTween.kill()
		TransitionTween = create_tween()
		TransitionTween.tween_property(self, "global_position", active_zone.fixed_position, 0.5).set_trans(Tween.TRANS_SINE)
		#global_position = active_zone.fixed_position
	
	if active_zone.limit_camera:
		limit_enabled = true
		limit_left = active_zone.limit_left
		limit_right = active_zone.limit_right
		limit_top = active_zone.limit_top
		limit_bottom = active_zone.limit_bottom
	else:
		limit_enabled = false
