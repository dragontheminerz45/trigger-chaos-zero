extends Node2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D

var speed: float = 300

func _physics_process(delta: float) -> void:
	global_position += Vector2(1,0).rotated(rotation) * speed * delta
	if ray_cast_2d.is_colliding():
		queue_free()

func _on_timeout_timeout() -> void:
	queue_free()
