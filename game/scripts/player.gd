extends CharacterBody3D

const TEAM_COLOR: Color = Color(1, 0.4, 0.2, 1)

# Controller
@export var device_id: int = 0

var input: InputInterface

# Movement
var mover: MoverInterface
var base_mover: MoverInterface
var mover_decorators: Array[String] = []
var jump_count: int = 0

# Shooting
var shooter: ShooterInterface
var base_shooter: ShooterInterface
var shooter_decorators: Array[String] = []
var shoot_cooldown: float = 0.0

@onready var aim_pivot: Node3D = $AimPivot
@onready var shoot_position: Node3D = $AimPivot/ShootPosition


func _ready():
	add_to_group(Constants.PLAYERS_GROUP)

	# input = GamepadInput.new(device_id)
	input = KeyboardMouseInput.new(self)

	base_mover = DefaultMover.new(5.0)
	mover = base_mover

	base_shooter = DefaultShooter.new()
	shooter = base_shooter


func _physics_process(delta):
	input.update()
	_process_shooting(delta)
	_process_movement(delta)


func _process_shooting(delta: float) -> void:
	if shoot_cooldown > 0:
		shoot_cooldown -= delta

	var aim_input = input.get_aim_direction()
	if aim_input.length() > 0:
		var angle = -atan2(aim_input.y, aim_input.x)
		aim_pivot.rotation.z = angle

	if input.is_shoot_pressed() and shoot_cooldown <= 0:
		_shoot()
		shoot_cooldown = shooter.get_shoot_delay()


func _process_movement(delta: float) -> void:
	var context = MovementContext.new(velocity.y, is_on_floor(), input.is_jump_just_pressed(), jump_count)
	velocity = mover.process_movement(input.get_movement(), delta, context)
	jump_count = context.jump_count
	move_and_slide()


func _shoot():
	var direction = (shoot_position.global_position - global_position).normalized()
	var context = ShootingContext.new(shoot_position.global_position, direction, TEAM_COLOR, get_parent())
	shooter.shoot(context)


func apply_powerup(powerup_name: String) -> bool:
	var registry = PowerUpRegistry.new()

	if registry.is_movement_powerup(powerup_name):
		if not mover_decorators.has(powerup_name):
			mover_decorators.append(powerup_name)
			_rebuild_movement_chain()
			return true
	elif registry.is_shooting_powerup(powerup_name):
		if not shooter_decorators.has(powerup_name):
			shooter_decorators.append(powerup_name)
			_rebuild_shooting_chain()
			return true

	return false


func _rebuild_movement_chain():
	var registry = PowerUpRegistry.new()
	mover = base_mover
	for powerup_name in mover_decorators:
		mover = registry.create_movement_decorator(powerup_name, mover)


func _rebuild_shooting_chain():
	var registry = PowerUpRegistry.new()
	shooter = base_shooter
	for powerup_name in shooter_decorators:
		shooter = registry.create_shooting_decorator(powerup_name, shooter)
