extends RefCounted
class_name Mover

## Abstract interface for movers.
## Implementations should override these methods.


func process_movement(_input_vector: Vector2, _delta: float) -> Vector2:
	push_error("Mover.process_movement() not implemented")
	return Vector2.ZERO

