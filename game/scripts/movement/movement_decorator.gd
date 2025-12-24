class_name MoverDecorator
extends Mover

var wrapped_mover: Mover


func _init(mover: Mover):
	wrapped_mover = mover


func process_movement(input_vector: Vector2, delta: float, context: MovementContext) -> Vector3:
	return wrapped_mover.process_movement(input_vector, delta, context)
