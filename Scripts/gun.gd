extends Node2D

signal ammo_changed(ammo_amount, reserve_amount)

@export var usable_ammo: int = 15
@export var reserved_ammo: int = 30
@export var max_usable_ammo: int = 15
@export var max_reserved_ammo: int = 120
@export var infinite_ammo: bool = true

@onready var marker_2d: Marker2D = $Marker2D
@onready var shoot_timer: Timer = $ShootTimer
@onready var reload_timer: Timer = $ReloadTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const BULLET = preload("res://Scenes/bullet.tscn")

var time_between_shot: float = 0.25
var can_shoot: bool = true
var can_reload = true

func _ready() -> void:
	shoot_timer.wait_time = time_between_shot
	if infinite_ammo:
		reserved_ammo = 99999
		max_reserved_ammo = 99999

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot()
		can_shoot = false
		shoot_timer.start()
	
	if Input.is_action_just_pressed("reload") and can_reload:
		reload()

func shoot():
	if usable_ammo > 0:
		animation_player.play("shoot")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = marker_2d.global_position
		new_bullet.global_rotation = marker_2d.global_rotation
		get_parent().add_child(new_bullet)
		usable_ammo -= 1
		emit_signal("ammo_changed", usable_ammo, reserved_ammo)
	elif can_reload:
		reload()

func reload():
	if usable_ammo >= max_usable_ammo or reserved_ammo <= 0:
		return

	reload_timer.start()
	can_shoot = false
	can_reload = false
	animation_player.play("reload")
	
	await reload_timer.timeout
	
	can_shoot = true
	can_reload = true

	var ammo_needed = max_usable_ammo - usable_ammo
	var ammo_to_reload = min(ammo_needed, reserved_ammo)

	usable_ammo += ammo_to_reload
	if !infinite_ammo:
		reserved_ammo -= ammo_to_reload

	emit_signal("ammo_changed", usable_ammo, reserved_ammo)

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
