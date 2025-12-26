class_name Flashlight
extends RigidBody3D

@export var target: Node3D
@export var spring_force: float = 50.0
@export var damping: float = 10.0
@export var rotation_speed: float = 35.0


func _ready() -> void:
	gravity_scale = 0.0
	lock_rotation = true
	top_level = true


func _physics_process(delta: float) -> void:
	if target == null:
		return

	var target_pos = target.global_position
	var current_pos = global_position
	var displacement = target_pos - current_pos

	var spring = displacement * spring_force
	var damp = linear_velocity * damping
	var force = spring - damp

	apply_central_force(force)

	var aim_origin = target.get_parent().global_position
	var aim_direction = (target.global_position - aim_origin).normalized()
	var target_basis = Basis.looking_at(aim_direction, Vector3.UP)
	global_transform.basis = global_transform.basis.slerp(target_basis, rotation_speed * delta)
