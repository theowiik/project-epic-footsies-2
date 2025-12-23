class_name DefaultMover
extends MoverInterface

const JUMP_VELOCITY = 10.0
const GRAVITY = 20.0

var speed: float = 5.0


func _init(movement_speed: float = 5.0):
	speed = movement_speed


func process_movement(input_vector: Vector2, delta: float, context: Dictionary) -> Vector3:
	var velocity = Vector3.ZERO
	var current_velocity_y: float = context.get("velocity_y", 0.0)
	var is_on_floor: bool = context.get("is_on_floor", false)
	var jump_pressed: bool = context.get("jump_pressed", false)

	# Horizontal movement
	velocity.x = input_vector.x * speed
	velocity.z = 0

	# Vertical movement (gravity and jumping)
	velocity.y = current_velocity_y
	if not is_on_floor:
		velocity.y -= GRAVITY * delta
	if jump_pressed and is_on_floor:
		velocity.y = JUMP_VELOCITY

	return velocity
