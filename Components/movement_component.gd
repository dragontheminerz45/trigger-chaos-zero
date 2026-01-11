class_name EnemyMovementComponent extends Node

@export var actor: CharacterBody2D
@export var sprite: Node2D
@export var stationary: bool = false

@export var speed: int = 50
@export var direction: Vector2 = Vector2.ZERO

@export var movement_limit_toggle: bool = false
@export var movement_limit: Vector2 = Vector2.ZERO

@export var ray_cast_left: RayCast2D
@export var ray_cast_right: RayCast2D
@export var ray_cast_top: RayCast2D
@export var ray_cast_bottom: RayCast2D

var origin: Vector2

func _ready() -> void:
	origin = actor.position

func _physics_process(delta: float) -> void:
	if !stationary:
		if (ray_cast_left and ray_cast_right) and (ray_cast_left.is_colliding() or ray_cast_right.is_colliding()):
			direction.x *= -1
		if (ray_cast_top and ray_cast_bottom) and (ray_cast_top.is_colliding() or ray_cast_bottom.is_colliding()):
			direction.y *= -1
		if movement_limit_toggle and (movement_limit.x < abs(origin.x - actor.position.x)):
			direction.x *= -1
		if movement_limit_toggle and (movement_limit.y < abs(origin.y - actor.position.y)):
			direction.y *= -1
		
		sprite.scale.x = sign(-direction.x)
		
		actor.position.x += direction.x * speed * delta
		actor.position.y += direction.y * speed * delta
		actor.move_and_slide()
