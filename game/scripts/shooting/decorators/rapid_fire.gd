extends ShooterDecorator
class_name RapidFireDecorator


func get_shoot_delay() -> float:
	return base_shooter.get_shoot_delay() * 0.5
