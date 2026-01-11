extends CharacterBody2D

@onready var hurtbox: Hurtbox = $Hurtbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var shaker = Shaker.new(animated_sprite_2d)

func _ready() -> void:
	hurtbox.hurt.connect(func(_other_hitbox: Hitbox):
		animation_player.play("hit_flash")
		shaker.shake(2, 0.2)
	)
