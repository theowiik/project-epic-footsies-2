class_name Player
extends CharacterBody3D

const TEAM_COLOR: Color = Color(1, 0.4, 0.2, 1)

# Controller
@export var device_id: int = 0

var input: InputInterface

# Movement
var mover: MoverInterface
var base_mover: MoverInterface
var mover_decorator_names: Array[String] = []
var jump_count: int = 0
var external_velocity: Vector3 = Vector3.ZERO

# Shooting
var shooter: ShooterInterface
var base_shooter: ShooterInterface
var shooter_decorator_names: Array[String] = []
var shoot_cooldown: float = 0.0

@onready var aim_pivot: Node3D = $AimPivot
@onready var shoot_position: Node3D = $AimPivot/ShootPosition
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var body: Node3D = $Body

var animation_manager: AnimationManager


func _ready():
	input = KeyboardMouseInput.new(self)

	base_mover = BaseMover.new(5.0)
	mover = base_mover

	base_shooter = BaseShooter.new()
	shooter = base_shooter

	animation_manager = AnimationManager.new(animation_player, body)


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
		var direction = (shoot_position.global_position - global_position).normalized()
		var context = ShootingContext.new(
			shoot_position.global_position, direction, TEAM_COLOR, get_parent(), self
		)

		shooter.shoot(context)
		shoot_cooldown = shooter.get_shoot_delay()


func _process_movement(delta: float) -> void:
	var context = MovementContext.new(
		velocity.y, is_on_floor(), input.is_jump_just_pressed(), jump_count
	)

	velocity = mover.process_movement(input.get_movement(), delta, context)
	jump_count = context.jump_count

	# Apply and decay external velocity (knockback, recoil, etc.)
	velocity += external_velocity
	external_velocity = external_velocity.lerp(Vector3.ZERO, 10.0 * delta)
	if external_velocity.length() < 0.1:
		external_velocity = Vector3.ZERO

	move_and_slide()
	animation_manager.update(velocity, is_on_floor())


func apply_impulse(impulse: Vector3) -> void:
	external_velocity += impulse


func apply_crystal(crystal_name: String) -> bool:
	var registry = CrystalRegistry.new()

	if registry.is_movement_crystal(crystal_name):
		mover_decorator_names.append(crystal_name)
		_rebuild_movement_chain()
		return true

	if registry.is_shooting_crystal(crystal_name):
		shooter_decorator_names.append(crystal_name)
		_rebuild_shooting_chain()
		return true

	return false


func _rebuild_movement_chain():
	var registry = CrystalRegistry.new()
	mover = base_mover
	for crystal_name in mover_decorator_names:
		mover = registry.create_movement_decorator(crystal_name, mover)


func _rebuild_shooting_chain():
	var registry = CrystalRegistry.new()
	shooter = base_shooter
	for crystal_name in shooter_decorator_names:
		shooter = registry.create_shooting_decorator(crystal_name, shooter)
