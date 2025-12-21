extends ShootingCrystal
class_name FastBulletsCrystal

var speed_multiplier: float = 2.0


func get_bullet_speed() -> float:
	return base_shooting.get_bullet_speed() * speed_multiplier

