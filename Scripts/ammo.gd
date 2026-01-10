extends Label

@onready var gun = get_node("../../Player/RotationOffset/Gun")

func _ready() -> void:
	gun.ammo_changed.connect(_on_gun_ammo_changed)

func _on_gun_ammo_changed(ammo_amount: int, reserve_amount: int) -> void:
	change_text(ammo_amount, reserve_amount)

func change_text(ammo_amount, reserve_amount) -> void:
	if reserve_amount == 99999:
		text = "AMMO: " + str(ammo_amount) + "/-"
	else:
		text = "AMMO: " + str(ammo_amount) + "/" + str(reserve_amount)
