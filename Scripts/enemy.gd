extends CharacterBody2D

@export var stats: Stats :
	set(value):
		stats = value
		if value is not Stats: return
		stats = stats.duplicate()

@export var player = preload("res://Scenes/player.tscn")

@onready var hurtbox: Hurtbox = $Hurtbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var shaker = Shaker.new(sprite_2d)

func _ready() -> void:
	hurtbox.hurt.connect(func(other_hitbox: Hitbox):
		stats.health -= other_hitbox.damage
		animation_player.play("hit_flash")
		shaker.shake(2, 0.2)
	)
	stats.no_health.connect(func():
		queue_free()
	)
