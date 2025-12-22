extends MoverInterface
class_name MoverDecorator

var base_mover: MoverInterface


func _init(mover: MoverInterface):
	base_mover = mover


func process_movement(input_vector: Vector2, delta: float) -> Vector2:
	return base_mover.process_movement(input_vector, delta)
