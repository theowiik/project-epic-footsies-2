extends MovementCrystal
class_name PhastCrystal

var speed_multiplier: float = 1.6


func process_movement(input_vector: Vector2, delta: float) -> Vector2:
	var base_velocity = base_movement.process_movement(input_vector, delta)
	base_velocity.x *= speed_multiplier
	return base_velocity

