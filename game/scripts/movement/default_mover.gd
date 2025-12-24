class_name DefaultMover
extends MoverInterface

const JUMP_VELOCITY = 10.0
const GRAVITY = 20.0

var speed: float = 5.0


func _init(movement_speed: float = 5.0):
	speed = movement_speed


func process_movement(input_vector: Vector2, delta: float, context: MovementContext) -> Vector3:
	var velocity = Vector3.ZERO

	# Horizontal movement
	velocity.x = input_vector.x * speed
	velocity.z = 0

	# Vertical movement (gravity and jumping)
	velocity.y = context.velocity_y
	if not context.is_on_floor:
		velocity.y -= GRAVITY * delta
	if context.jump_pressed and context.is_on_floor:
		velocity.y = JUMP_VELOCITY

	return velocity
