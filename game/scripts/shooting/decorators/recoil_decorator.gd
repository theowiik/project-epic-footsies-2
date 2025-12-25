class_name RecoilDecorator
extends ShooterDecorator

var player: CharacterBody3D
var knockback_strength: float = 3.0


func _init(shooter: Shooter, player_ref: CharacterBody3D):
	super(shooter)
	player = player_ref


func shoot(context: ShootingContext) -> void:
	wrapped_shooter.shoot(context)

	var knockback_direction = -context.direction
	knockback_direction.y = 0

	player.apply_impulse(knockback_direction.normalized() * knockback_strength)
