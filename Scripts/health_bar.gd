extends ProgressBar


func _on_player_health_change(health_points: int) -> void:
	value = health_points
