class_name RecoilDecorator
extends ShooterDecorator

var knockback_strength: float = 3.0


func shoot(context: ShootingContext) -> void:
	wrapped_shooter.shoot(context)

	if not context.player:
		return

	var knockback_direction = -context.direction

	context.player.apply_impulse(knockback_direction.normalized() * knockback_strength)
