extends ShootingBehavior
class_name ShootingDecorator

var base_shooting: ShootingBehavior


func _init(shooting: ShootingBehavior):
	base_shooting = shooting


func get_bullet_speed() -> float:
	return base_shooting.get_bullet_speed()


func shoot(from_position: Vector2, direction: Vector2, owner_node: Node2D) -> void:
	base_shooting.shoot(from_position, direction, owner_node)
