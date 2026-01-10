extends CharacterBody2D

signal game_over
signal health_change(health_points: int)

@export var max_speed = 120
@export var acceleration = 1000
@export var air_acceleration = 2000
@export var friction = 1000
@export var air_friction = 500
@export var up_gravity = 500
@export var down_gravity = 600
@export var jump_height = 250
@export var dash_speed = 300

@export var health_points = 100

var dashing = false
var can_dash = true

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var rotation_offset: Node2D = $RotationOffset
@onready var dash_timer: Timer = $DashTimer
@onready var dash_again_timer: Timer = $DashAgainTimer
@onready var gun: Node2D = $RotationOffset/Gun

func _physics_process(delta: float) -> void:
	
	var x_input = Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_height

	if Input.is_action_just_pressed("dash") and x_input and can_dash:
		dashing = true
		can_dash = false
		dash_timer.start()
		dash_again_timer.start()

	if x_input:
		if dashing:
			velocity.x = x_input * dash_speed
		else:
			accelerate_horizontally(x_input, delta)
		animated_sprite_2d.scale.x = sign(x_input)
		gun.scale.y = sign(x_input)
		animated_sprite_2d.play("run")
	else:
		apply_friction(delta)
		animated_sprite_2d.play("idle")
	
	apply_gravity(delta)
	if not is_on_floor():
		if velocity.y < -50:
			animated_sprite_2d.play("jump_up")
		elif velocity.y >= -50 and velocity.y <= 50:
			animated_sprite_2d.play("jump_max")
		elif velocity.y > 50:
			animated_sprite_2d.play("jump_down")

	move_and_slide()

	rotation_offset.rotation = lerp_angle(rotation_offset.rotation, ( get_global_mouse_position() - global_position).angle(), 10*delta )

func accelerate_horizontally(h_direction: float, delta: float) -> void:
	var acceleration_amt = acceleration
	if not is_on_floor(): acceleration_amt = air_acceleration
	velocity.x = move_toward(velocity.x, max_speed * h_direction, acceleration_amt * delta)

func apply_friction(delta) -> void:
	var friction_amt = friction
	if not is_on_floor(): friction_amt = air_friction
	velocity.x = move_toward(velocity.x, 0.0, friction_amt * delta)

func apply_gravity(delta) -> void:
	if not is_on_floor():
		if velocity.y <= 0 :
			velocity.y += up_gravity * delta
		else:
			velocity.y += down_gravity * delta

func hurt() -> void:
	health_points -= 10
	if health_points <= 0:
		print("u are ded")
		emit_signal("game_over")

func _on_dash_timer_timeout() -> void:
	dashing = false

func _on_dash_again_timer_timeout() -> void:
	can_dash = true
