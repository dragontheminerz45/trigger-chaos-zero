class_name HealthComponent extends Node

@export var max_health: int = 100
var health: int

signal dead
signal health_changed(health_points: int)

func _ready() -> void:
	health = max_health

func take_damage(damage: int) -> void:
	health -= damage
	health_changed.emit(health)
	if health <= 0:
		emit_signal("dead")
		get_parent().queue_free()
