extends CharacterBody2D

@export var stats: Stats :
	set(value):
		stats = value
		if value is not Stats: return
		stats = stats.duplicate()

@onready var hurtbox: Hurtbox = $Hurtbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var shaker = Shaker.new(animated_sprite_2d)

signal defeated()

func _ready() -> void:
	hurtbox.hurt.connect(func(other_hitbox: Hitbox):
		stats.health -= other_hitbox.damage
		animation_player.play("hit_flash")
		shaker.shake(2, 0.2)
	)
	stats.no_health.connect(func():
		defeated.emit()
		queue_free()
	)
