extends CharacterBody3D

const JUMP_VELOCITY = 10.0
const GRAVITY = 20.0

var facing_direction: int = 1  # 1 for right, -1 for left

var movement_behavior: MovementBehavior
var base_movement: MovementBehavior
var movement_crystals: Array[String] = []
var k_was_pressed: bool = false

var shooting_behavior: ShootingBehavior
var base_shooting: ShootingBehavior
var shooting_crystals: Array[String] = []
var j_was_pressed: bool = false
var l_was_pressed: bool = false


func _ready():
	base_movement = BasicMovement.new(5.0)
	movement_behavior = base_movement

	base_shooting = BasicShooting.new()
	shooting_behavior = base_shooting

	print("Player is ready")


func _physics_process(delta):
	# Debug toggles
	var k_pressed = Input.is_physical_key_pressed(KEY_K)
	if k_pressed and not k_was_pressed:
		toggle_movement_crystal("phast")
	k_was_pressed = k_pressed

	var j_pressed = Input.is_physical_key_pressed(KEY_J)
	if j_pressed and not j_was_pressed:
		toggle_shooting_crystal("triple_shot")
	j_was_pressed = j_pressed

	var l_pressed = Input.is_physical_key_pressed(KEY_L)
	if l_pressed and not l_was_pressed:
		toggle_shooting_crystal("fast_bullets")
	l_was_pressed = l_pressed

	# Shooting
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		shoot()

	# Apply gravity
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle horizontal movement
	var input_vector = get_input()
	var movement = movement_behavior.process_movement(input_vector, delta)
	velocity.x = movement.x
	velocity.z = 0

	# Update facing direction based on movement
	if input_vector.x > 0:
		facing_direction = 1
	elif input_vector.x < 0:
		facing_direction = -1

	move_and_slide()


func toggle_movement_crystal(crystal_name: String):
	if crystal_name in movement_crystals:
		movement_crystals.erase(crystal_name)
		print(crystal_name, " OFF")
	else:
		movement_crystals.append(crystal_name)
		print(crystal_name, " ON")
	rebuild_movement_behavior()


func toggle_shooting_crystal(crystal_name: String):
	if crystal_name in shooting_crystals:
		shooting_crystals.erase(crystal_name)
		print(crystal_name, " OFF")
	else:
		shooting_crystals.append(crystal_name)
		print(crystal_name, " ON")
	rebuild_shooting_behavior()


func rebuild_movement_behavior():
	movement_behavior = base_movement
	for crystal_name in movement_crystals:
		match crystal_name:
			"phast":
				movement_behavior = PhastCrystal.new(movement_behavior)


func rebuild_shooting_behavior():
	shooting_behavior = base_shooting
	for crystal_name in shooting_crystals:
		match crystal_name:
			"triple_shot":
				shooting_behavior = TripleShotCrystal.new(shooting_behavior)
			"fast_bullets":
				shooting_behavior = FastBulletsCrystal.new(shooting_behavior)


func shoot():
	var direction = get_aim_direction()
	shooting_behavior.shoot(global_position, direction, self)


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
