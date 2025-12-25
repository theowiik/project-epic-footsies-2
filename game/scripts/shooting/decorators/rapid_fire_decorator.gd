class_name RapidFireDecorator
extends ShooterDecorator

var delay_multiplier: float = 0.5


func _init(shooter: ShooterInterface, multiplier: float = 0.5):
	super(shooter)
	delay_multiplier = multiplier


func get_shoot_delay() -> float:
	return wrapped_shooter.get_shoot_delay() * delay_multiplier
