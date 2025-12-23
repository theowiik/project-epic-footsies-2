class_name FastBulletsDecorator
extends ShooterDecorator

var speed_multiplier: float = 2.0


func get_bullet_speed() -> float:
	return base_shooter.get_bullet_speed() * speed_multiplier
