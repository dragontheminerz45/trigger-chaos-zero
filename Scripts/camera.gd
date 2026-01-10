extends Camera2D

@onready var top_left_limit: Node2D = $"../TopLeftLimit"
@onready var bottom_right_limit: Node2D = $"../BottomRightLimit"

var desired_offset: Vector2

var min_offset = -100
var max_offset = 100

func _ready() -> void:
	if top_left_limit and bottom_right_limit:
		limit_enabled = true
		limit_top = top_left_limit.position.y
		limit_left = top_left_limit.position.x
		limit_bottom = bottom_right_limit.position.y
		limit_right = bottom_right_limit.position.x

func _process(delta: float) -> void:
	desired_offset = (get_global_mouse_position() - position) * 0.5
	desired_offset.x = clamp(desired_offset.x, min_offset, max_offset)
	desired_offset.y = clamp(desired_offset.y, min_offset/2.0, max_offset/2.0)
	
	global_position = get_parent().get_node("Player").global_position + desired_offset
