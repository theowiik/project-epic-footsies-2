extends Mover
class_name MoverDecorator

## Base decorator for movers.
## Wraps another Mover and delegates by default.
## Subclasses override specific methods to modify behavior.

var base_mover: Mover


func _init(mover: Mover):
	base_mover = mover


func process_movement(input_vector: Vector2, delta: float) -> Vector2:
	return base_mover.process_movement(input_vector, delta)

