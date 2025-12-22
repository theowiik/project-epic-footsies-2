extends ShooterInterface
class_name DefaultShooter

var bullet_scene: PackedScene = load("res://objects/bullet.tscn")
var bullet_speed: float = 100.0


func get_bullet_scene() -> PackedScene:
	return bullet_scene


func get_bullet_speed() -> float:
	return bullet_speed


func shoot(from_position: Vector3, direction: Vector3, owner_node: Node3D) -> void:
	spawn_bullet(from_position, direction, owner_node)


func spawn_bullet(from_position: Vector3, direction: Vector3, owner_node: Node3D) -> void:
	var bullet = get_bullet_scene().instantiate()
	bullet.position = from_position
	bullet.speed = get_bullet_speed()
	bullet.set_direction(direction)
	owner_node.get_parent().add_child(bullet)
