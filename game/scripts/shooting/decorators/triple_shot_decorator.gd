class_name TripleShotDecorator
extends ShooterDecorator

var spread_angle: float = 15.0


func _init(shooter: Shooter, angle: float = 15.0):
	super(shooter)
	spread_angle = angle


func shoot(context: ShootingContext) -> void:
	var left_dir = context.direction.rotated(Vector3.FORWARD, deg_to_rad(spread_angle))
	context.extra_shots.append({"direction": left_dir})

	var right_dir = context.direction.rotated(Vector3.FORWARD, -deg_to_rad(spread_angle))
	context.extra_shots.append({"direction": right_dir})

	wrapped_shooter.shoot(context)
