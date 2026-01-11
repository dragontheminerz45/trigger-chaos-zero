class_name Hurtbox extends Area2D

@export var health_component: HealthComponent
var is_invincible := false

signal hurt(other_hitbox: Hitbox)

func take_hit(other_hitbox: Hitbox) -> void:
	if is_invincible: return
	hurt.emit(other_hitbox)
	if health_component and health_component.has_method("take_damage"):
		health_component.take_damage(other_hitbox.damage)
