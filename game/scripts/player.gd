extends CharacterBody3D

var facing_direction: int = 1

# Movement
var mover: MoverInterface
var base_mover: MoverInterface
var mover_decorators: Array[String] = []
var k_was_pressed: bool = false

# Shooting
var shooter: ShooterInterface
var base_shooter: ShooterInterface
var shooter_decorators: Array[String] = []
var j_was_pressed: bool = false
var l_was_pressed: bool = false


func _ready():
	base_mover = DefaultMover.new(5.0)
	mover = base_mover

	base_shooter = DefaultShooter.new()
	shooter = base_shooter

	print("Player is ready")


func _physics_process(delta):
	# Debug toggles
	var k_pressed = Input.is_physical_key_pressed(KEY_K)
	if k_pressed and not k_was_pressed:
		toggle_mover_decorator("phast")
	k_was_pressed = k_pressed

	var j_pressed = Input.is_physical_key_pressed(KEY_J)
	if j_pressed and not j_was_pressed:
		toggle_shooter_decorator("triple_shot")
	j_was_pressed = j_pressed

	var l_pressed = Input.is_physical_key_pressed(KEY_L)
	if l_pressed and not l_was_pressed:
		toggle_shooter_decorator("fast_bullets")
	l_was_pressed = l_pressed

	# Shooting
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		shoot()

	# Handle all movement through the mover
	var input_vector = get_input()
	var context = {
		"velocity_y": velocity.y,
		"is_on_floor": is_on_floor(),
		"jump_pressed": Input.is_action_just_pressed("ui_accept")
	}
	velocity = mover.process_movement(input_vector, delta, context)

	# Update facing direction based on movement
	if input_vector.x > 0:
		facing_direction = 1
	elif input_vector.x < 0:
		facing_direction = -1

	move_and_slide()


func toggle_mover_decorator(decorator_name: String):
	if decorator_name in mover_decorators:
		mover_decorators.erase(decorator_name)
		print(decorator_name, " OFF")
	else:
		mover_decorators.append(decorator_name)
		print(decorator_name, " ON")
	rebuild_mover()


func toggle_shooter_decorator(decorator_name: String):
	if decorator_name in shooter_decorators:
		shooter_decorators.erase(decorator_name)
		print(decorator_name, " OFF")
	else:
		shooter_decorators.append(decorator_name)
		print(decorator_name, " ON")
	rebuild_shooter()


func rebuild_mover():
	mover = base_mover
	for decorator_name in mover_decorators:
		match decorator_name:
			"phast":
				mover = PhastDecorator.new(mover)


func rebuild_shooter():
	shooter = base_shooter
	for decorator_name in shooter_decorators:
		match decorator_name:
			"triple_shot":
				shooter = TripleShotDecorator.new(shooter)
			"fast_bullets":
				shooter = FastBulletsDecorator.new(shooter)


func shoot():
	var direction = get_aim_direction()
	shooter.shoot(global_position, direction, self)


func get_aim_direction() -> Vector3:
	var camera = get_viewport().get_camera_3d()
	if not camera:
		return Vector3.RIGHT * facing_direction

	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = camera.project_ray_normal(mouse_pos)

	if abs(ray_direction.z) > 0.0001:
		var t = (global_position.z - ray_origin.z) / ray_direction.z
		var aim_point = ray_origin + ray_direction * t
		var direction = (aim_point - global_position).normalized()
		return direction

	return Vector3.RIGHT * facing_direction


func get_input() -> Vector2:
	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1

	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1

	return input_vector
