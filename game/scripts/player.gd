extends CharacterBody3D

const team_color: Color = Color(1, 0.4, 0.2, 1)

var facing_direction: int = 1

@export var device_id: int = 0
var input: InputInterface

var mover: MoverInterface
var base_mover: MoverInterface
var mover_decorators: Array[String] = []

var shooter: ShooterInterface
var base_shooter: ShooterInterface
var shooter_decorators: Array[String] = []
var shoot_cooldown: float = 0.0


func _ready():
	input = GamepadInput.new(device_id)

	base_mover = DefaultMover.new(5.0)
	mover = base_mover

	base_shooter = DefaultShooter.new()
	shooter = base_shooter


func _physics_process(delta):
	input.update()

	if shoot_cooldown > 0:
		shoot_cooldown -= delta

	if input.is_shoot_pressed() and shoot_cooldown <= 0:
		shoot()
		shoot_cooldown = shooter.get_shoot_delay()

	var input_vector = input.get_movement()
	var context = {
		"velocity_y": velocity.y,
		"is_on_floor": is_on_floor(),
		"jump_pressed": input.is_jump_just_pressed()
	}
	velocity = mover.process_movement(input_vector, delta, context)

	var aim = input.get_aim_direction()
	if aim.x != 0:
		facing_direction = 1 if aim.x > 0 else -1
	elif input_vector.x > 0:
		facing_direction = 1
	elif input_vector.x < 0:
		facing_direction = -1

	move_and_slide()


func toggle_mover_decorator(decorator_name: String):
	if decorator_name in mover_decorators:
		mover_decorators.erase(decorator_name)
	else:
		mover_decorators.append(decorator_name)
	rebuild_mover()


func toggle_shooter_decorator(decorator_name: String):
	if decorator_name in shooter_decorators:
		shooter_decorators.erase(decorator_name)
	else:
		shooter_decorators.append(decorator_name)
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
			"rapid_fire":
				shooter = RapidFireDecorator.new(shooter)


func shoot():
	var direction = get_aim_direction()
	shooter.shoot(global_position, direction, team_color, get_parent())


func get_aim_direction() -> Vector3:
	var aim_2d = input.get_aim_direction()

	if aim_2d != Vector2.ZERO:
		return Vector3(aim_2d.x, -aim_2d.y, 0).normalized()

	return Vector3.RIGHT * facing_direction
