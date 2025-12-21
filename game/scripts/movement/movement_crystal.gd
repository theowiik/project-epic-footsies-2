extends MovementBehavior
class_name MovementCrystal

var base_movement: MovementBehavior


func _init(movement: MovementBehavior):
	base_movement = movement


func process_movement(input_vector: Vector2, delta: float) -> Vector2:
	return base_movement.process_movement(input_vector, delta)
