class_name Flashlight
extends RigidBody3D

const SPRING_FORCE: float = 300.0
const DAMPING: float = 10.0
const ROTATION_SPEED: float = 90.0

var target_position: Node3D = null
var aim_origin: Node3D = null

@onready var hand_mesh: MeshInstance3D = $Visuals/HandOnly/flashlight_hand
@onready var shoot_position: Node3D = $ShootPosition


func _ready() -> void:
	gravity_scale = 0.0
	lock_rotation = true
	top_level = true


func set_color(color: Color) -> void:
	var material = hand_mesh.get_active_material(0)
	if material:
		material = material.duplicate()
		material.albedo_color = color
		hand_mesh.set_surface_override_material(0, material)


func _physics_process(delta: float) -> void:
	_move_towards_target_position(delta)


func _move_towards_target_position(delta: float) -> void:
	if target_position == null or aim_origin == null:
		return

	# Position
	var target_pos = target_position.global_position
	var current_pos = global_position
	var displacement = target_pos - current_pos

	var spring = displacement * SPRING_FORCE
	var damp = linear_velocity * DAMPING
	var force = spring - damp

	apply_central_force(force)

	# Rotation
	var aim_direction = (target_position.global_position - aim_origin.global_position).normalized()

	var target_basis = Basis.looking_at(aim_direction, Vector3.UP)
	global_transform.basis = global_transform.basis.slerp(target_basis, ROTATION_SPEED * delta)
