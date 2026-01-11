class_name PlayerMovementComponent extends Node

@export var actor: CharacterBody2D

@export var max_speed = 120
@export var acceleration = 1000
@export var air_acceleration = 2000
@export var friction = 1000
@export var air_friction = 500
@export var up_gravity = 500
@export var down_gravity = 600
@export var jump_height = 250
@export var dash_speed = 300

var dashing = false
var can_dash = true

@export var dash_timer: Timer
@export var dash_again_timer: Timer
@export var animated_sprite_2d: AnimatedSprite2D
@export var rotation_offset: Node2D

func _physics_process(delta: float) -> void:
	
	var x_input = Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("jump") and actor.is_on_floor():
		actor.velocity.y = -jump_height

	if Input.is_action_just_pressed("dash") and x_input and can_dash:
		dashing = true
		can_dash = false
		dash_timer.start()
		dash_again_timer.start()

	if x_input:
		if dashing:
			actor.velocity.x = x_input * dash_speed
		else:
			accelerate_horizontally(x_input, delta)
		animated_sprite_2d.scale.x = sign(x_input)
		if rotation_offset:
			rotation_offset.find_child("Gun").scale.y = sign(x_input)
		animated_sprite_2d.play("run")
	else:
		apply_friction(delta)
		animated_sprite_2d.play("idle")
	
	apply_gravity(delta)
	if not actor.is_on_floor():
		if actor.velocity.y < -50:
			animated_sprite_2d.play("jump_up")
		elif actor.velocity.y >= -50 and actor.velocity.y <= 50:
			animated_sprite_2d.play("jump_max")
		elif actor.velocity.y > 50:
			animated_sprite_2d.play("jump_down")

	actor.move_and_slide()
	
	if rotation_offset:
		rotation_offset.rotation = lerp_angle(rotation_offset.rotation, ( actor.get_global_mouse_position() - actor.global_position).angle(), 10*delta )

func accelerate_horizontally(h_direction: float, delta: float) -> void:
	var acceleration_amt = acceleration
	if not actor.is_on_floor(): acceleration_amt = air_acceleration
	actor.velocity.x = move_toward(actor.velocity.x, max_speed * h_direction, acceleration_amt * delta)

func apply_friction(delta) -> void:
	var friction_amt = friction
	if not actor.is_on_floor(): friction_amt = air_friction
	actor.velocity.x = move_toward(actor.velocity.x, 0.0, friction_amt * delta)

func apply_gravity(delta) -> void:
	if not actor.is_on_floor():
		if actor.velocity.y <= 0 :
			actor.velocity.y += up_gravity * delta
		else:
			actor.velocity.y += down_gravity * delta

func _on_dash_timer_timeout() -> void:
	dashing = false

func _on_dash_again_timer_timeout() -> void:
	can_dash = true
