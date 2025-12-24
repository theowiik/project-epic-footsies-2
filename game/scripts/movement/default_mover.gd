class_name DefaultMover
extends MoverInterface

const JUMP_VELOCITY = 10.0
const GRAVITY = 20.0

var speed: float = 5.0


func _init(movement_speed: float = 5.0):
	speed = movement_speed


func process_movement(input_vector: Vector2, delta: float, context: MovementContext) -> Vector3:
	var velocity = Vector3.ZERO

	velocity.x = input_vector.x * speed
	velocity.z = 0
	velocity.y = context.velocity_y

	if context.is_on_floor:
		context.jump_count = 0
		if context.jump_pressed:
			context.jump_requested = true
	else:
		velocity.y -= GRAVITY * delta

	if context.jump_requested:
		velocity.y = JUMP_VELOCITY
		context.jump_count += 1
		context.jump_requested = false

	return velocity
