extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var invicibility_timer: Timer = $InvicibilityTimer
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shaker = Shaker.new(animated_sprite_2d)

func _ready() -> void:
	add_to_group("player")

func _on_hurtbox_hurt(_other_hitbox: Hitbox) -> void:
	hurtbox.is_invincible = true
	shaker.shake(2, 0.5)
	animation_player.play("hit_flash")
	invicibility_timer.start()

func _on_invicibility_timer_timeout() -> void:
	hurtbox.is_invincible = false
