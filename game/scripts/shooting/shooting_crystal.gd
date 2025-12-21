extends ShootingBehavior
class_name ShootingCrystal

var base_shooting: ShootingBehavior


func _init(shooting: ShootingBehavior):
	base_shooting = shooting


func get_bullet_speed() -> float:
	return base_shooting.get_bullet_speed()


func shoot(from_position: Vector3, direction: Vector3, owner_node: Node3D) -> void:
	base_shooting.shoot(from_position, direction, owner_node)

