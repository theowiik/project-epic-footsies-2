class_name FastBulletsDecorator
extends ShooterDecorator

var speed_multiplier: float = 2.0


func _init(shooter: ShooterInterface, decorator_config: ShooterDecoratorConfig = null):
	super(shooter, decorator_config)


func shoot(context: ShootingContext) -> void:
	context.speed_multiplier *= speed_multiplier
	wrapped_shooter.shoot(context)
