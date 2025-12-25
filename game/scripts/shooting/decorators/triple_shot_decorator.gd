class_name TripleShotDecorator
extends ShooterDecorator


func _init(shooter: ShooterInterface, decorator_config: ShooterDecoratorConfig = null):
	super(shooter, decorator_config)


func shoot(context: ShootingContext) -> void:
	context.extra_shots += 2
	wrapped_shooter.shoot(context)
