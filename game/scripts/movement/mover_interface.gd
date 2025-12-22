extends RefCounted
class_name MoverInterface


func process_movement(_input_vector: Vector2, _delta: float) -> Vector2:
	push_error("MoverInterface.process_movement() not implemented")
	return Vector2.ZERO
