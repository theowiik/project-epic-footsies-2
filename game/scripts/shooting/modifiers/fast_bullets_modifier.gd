class_name FastBulletsModifier
extends ShootingModifier

var speed_multiplier: float = 2.0


func _init(multiplier: float = 2.0):
	speed_multiplier = multiplier


func modify(context: ShootingContext) -> void:
	context.speed_multiplier *= speed_multiplier
