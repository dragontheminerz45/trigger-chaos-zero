extends ProgressBar

@export var player: CharacterBody2D

func _ready() -> void:
	player.find_child("HealthComponent").health_changed.connect(func(health):
		value = health
		)
	
