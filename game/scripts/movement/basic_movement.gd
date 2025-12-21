extends MovementBehavior
class_name BasicMovement

var speed: float = 5.0


func _init(movement_speed: float = 5.0):
	speed = movement_speed


func process_movement(input_vector: Vector2, delta: float) -> Vector2:
	var velocity = Vector2.ZERO

	velocity.x = input_vector.x * speed
	velocity.y = 0

	return velocity
