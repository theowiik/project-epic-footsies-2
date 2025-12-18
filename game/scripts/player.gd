extends CharacterBody2D

var movement_behavior: MovementBehavior
var base_movement: MovementBehavior
var has_phast: bool = false
var k_was_pressed: bool = false

var shooting_behavior: ShootingBehavior
var base_shooting: ShootingBehavior
var has_triple_shot: bool = false
var has_fast_bullets: bool = false
var j_was_pressed: bool = false
var l_was_pressed: bool = false


func _ready():
	base_movement = BasicMovement.new(300.0)
	movement_behavior = base_movement

	base_shooting = BasicShooting.new()
	shooting_behavior = base_shooting

	print("Player is ready")


func _physics_process(delta):
	# Movement powerup toggle
	var k_pressed = Input.is_physical_key_pressed(KEY_K)
	if k_pressed and not k_was_pressed:
		toggle_phast()
	k_was_pressed = k_pressed

	# Shooting powerup toggles
	var j_pressed = Input.is_physical_key_pressed(KEY_J)
	if j_pressed and not j_was_pressed:
		toggle_triple_shot()
	j_was_pressed = j_pressed

	var l_pressed = Input.is_physical_key_pressed(KEY_L)
	if l_pressed and not l_was_pressed:
		toggle_fast_bullets()
	l_was_pressed = l_pressed

	# Shooting
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		shoot()

	var input_vector = get_input()
	var movement = movement_behavior.process_movement(input_vector, delta)
	velocity.x = movement.x
	velocity.y += movement.y
	move_and_slide()


func toggle_phast():
	has_phast = !has_phast
	if has_phast:
		movement_behavior = PhastPowerup.new(base_movement)
		print("Phast activated!")
	else:
		movement_behavior = base_movement
		print("Phast deactivated!")


func shoot():
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	shooting_behavior.shoot(global_position, direction, self)


func toggle_triple_shot():
	has_triple_shot = !has_triple_shot
	update_shooting_behavior()
	print("Triple shot: ", "ON" if has_triple_shot else "OFF")


func toggle_fast_bullets():
	has_fast_bullets = !has_fast_bullets
	update_shooting_behavior()
	print("Fast bullets: ", "ON" if has_fast_bullets else "OFF")


func update_shooting_behavior():
	shooting_behavior = base_shooting

	if has_triple_shot:
		shooting_behavior = TripleShotPowerup.new(shooting_behavior)

	if has_fast_bullets:
		shooting_behavior = FastBulletsPowerup.new(shooting_behavior)


func get_input() -> Vector2:
	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1

	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1

	return input_vector
