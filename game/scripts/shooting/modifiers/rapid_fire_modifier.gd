class_name RapidFireModifier
extends ShootingModifier

var delay_multiplier: float = 0.5


func _init(multiplier: float = 0.5):
	delay_multiplier = multiplier


func modify(context: ShootingContext) -> void:
	context.delay_multiplier *= delay_multiplier
