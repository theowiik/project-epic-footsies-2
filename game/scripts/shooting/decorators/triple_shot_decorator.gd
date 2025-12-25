class_name TripleShotDecorator
extends ShooterDecorator


func shoot(context: ShootingContext) -> void:
	context.extra_shots += 2
	wrapped_shooter.shoot(context)
