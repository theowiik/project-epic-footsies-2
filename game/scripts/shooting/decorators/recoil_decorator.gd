class_name RecoilDecorator
extends ShooterDecorator

var player: CharacterBody3D
var knockback_strength: float = 3.0


func _init(shooter: Shooter, player_ref: CharacterBody3D, strength: float = 3.0):
	super(shooter)
	player = player_ref
	knockback_strength = strength


func shoot(context: ShootingContext) -> void:
	# First, delegate to wrapped shooter to actually shoot
	wrapped_shooter.shoot(context)

	# THEN apply knockback as a side effect
	# This is only possible with the decorator pattern!
	# The simpler "modify-then-execute" pattern couldn't run code AFTER shooting
	var knockback_direction = -context.direction
	knockback_direction.y = 0  # Only horizontal knockback

	# Apply impulse to player velocity
	if player:
		player.velocity += knockback_direction.normalized() * knockback_strength
