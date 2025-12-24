class_name PhastModifier
extends MovementModifier

var speed_multiplier: float = 1.6


func _init(multiplier: float = 1.6):
	speed_multiplier = multiplier


func modify(context: MovementContext) -> void:
	context.speed_multiplier *= speed_multiplier
