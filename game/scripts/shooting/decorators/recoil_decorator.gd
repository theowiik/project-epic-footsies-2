class_name RecoilDecorator
extends ShooterDecorator

var knockback_strength: float = 3.0


func _init(shooter: ShooterInterface, decorator_config: ShooterDecoratorConfig = null):
	super(shooter, decorator_config)


func shoot(context: ShootingContext) -> void:
	wrapped_shooter.shoot(context)

	if not config or not config.player:
		return

	var knockback_direction = -context.direction
	knockback_direction.y = 0

	config.player.apply_impulse(knockback_direction.normalized() * knockback_strength)
