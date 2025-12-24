extends CharacterBody3D

const TEAM_COLOR: Color = Color(1, 0.4, 0.2, 1)

# Controller
@export var device_id: int = 0

var input: InputInterface

# Movement
var mover: Mover
var movement_decorators: Array[MovementDecorator] = []
var jump_count: int = 0

# Shooting
var shooter: Shooter
var shooting_decorators: Array[ShootingDecorator] = []
var shoot_cooldown: float = 0.0

@onready var aim_pivot: Node3D = $AimPivot
@onready var shoot_position: Node3D = $AimPivot/ShootPosition


func _ready():
	add_to_group(Constants.PLAYERS_GROUP)

	# input = GamepadInput.new(device_id)
	input = KeyboardMouseInput.new(self)

	mover = Mover.new(5.0)
	shooter = Shooter.new()


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
			shoot_position.global_position, direction, TEAM_COLOR, get_parent()
		)

		# Apply all decorators
		for decorator in shooting_decorators:
			decorator.modify(context)

		# Shoot with modified context
		shooter.shoot(context)
		shoot_cooldown = shooter.shoot_delay * context.delay_multiplier


func _process_movement(delta: float) -> void:
	var context = MovementContext.new(
		velocity.y, is_on_floor(), input.is_jump_just_pressed(), jump_count
	)

	# Apply all decorators
	for decorator in movement_decorators:
		decorator.modify(context)

	# Process movement with modified context
	velocity = mover.process_movement(input.get_movement(), delta, context)
	jump_count = context.jump_count
	move_and_slide()


func apply_powerup(powerup_name: String) -> bool:
	var registry = PowerUpRegistry.new()

	if registry.is_movement_powerup(powerup_name):
		var decorator = registry.create_movement_decorator(powerup_name)
		if decorator:
			movement_decorators.append(decorator)
			return true
	elif registry.is_shooting_powerup(powerup_name):
		var decorator = registry.create_shooting_decorator(powerup_name)
		if decorator:
			shooting_decorators.append(decorator)
			return true

	return false
