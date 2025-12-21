extends ShootingBehavior
class_name BasicShooting

var bullet_scene: PackedScene


func _init():
	bullet_scene = load("res://objects/bullet.tscn")


func shoot(from_position: Vector3, direction: Vector3, owner_node: Node3D) -> void:
	spawn_bullet(from_position, direction, owner_node)


func spawn_bullet(from_position: Vector3, direction: Vector3, owner_node: Node3D) -> void:
	var bullet = bullet_scene.instantiate()
	bullet.position = from_position
	bullet.speed = get_bullet_speed()
	bullet.set_direction(direction)
	owner_node.get_parent().add_child(bullet)
