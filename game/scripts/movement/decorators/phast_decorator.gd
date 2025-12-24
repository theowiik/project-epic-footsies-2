class_name PhastDecorator
extends MoverDecorator

var speed_multiplier: float = 1.6


func process_movement(input_vector: Vector2, delta: float, context: MovementContext) -> Vector3:
	var base_velocity = base_mover.process_movement(input_vector, delta, context)
	base_velocity.x *= speed_multiplier
	return base_velocity
