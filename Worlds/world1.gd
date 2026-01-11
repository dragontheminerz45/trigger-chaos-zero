extends Node2D

@onready var gates: Node = $Gates
@onready var boss: CharacterBody2D = $Boss

func _on_boss_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and boss:
		for gate in gates.get_children():
			if gate is not StaticBody2D: return
			gate.visible = true
			gate.get_child(0).set_deferred("disabled", false)

func _on_boss_defeated() -> void:
	for gate in gates.get_children():
		if gate is not StaticBody2D: return
		gate.visible = false
		gate.get_child(0).set_deferred("disabled", true)
