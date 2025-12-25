class_name RapidFireDecorator
extends ShooterDecorator

var delay_multiplier: float = 0.5


func _init(shooter: ShooterInterface, decorator_config: ShooterDecoratorConfig = null):
	super(shooter, decorator_config)


func get_shoot_delay() -> float:
	return wrapped_shooter.get_shoot_delay() * delay_multiplier
