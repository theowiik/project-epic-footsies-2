extends ShooterInterface
class_name DefaultShooter

var bullet_scene: PackedScene = load("res://objects/bullet.tscn")
var bullet_speed: float = 30.0
var shoot_delay: float = 0.3


func get_bullet_scene() -> PackedScene:
	return bullet_scene


func get_bullet_speed() -> float:
	return bullet_speed


func get_shoot_delay() -> float:
	return shoot_delay


func shoot(from_position: Vector3, direction: Vector3, team_color: Color, parent: Node) -> void:
	spawn_bullet(from_position, direction, team_color, parent)


func spawn_bullet(
	from_position: Vector3, direction: Vector3, team_color: Color, parent: Node
) -> void:
	var bullet = get_bullet_scene().instantiate()
	bullet.position = from_position
	bullet.speed = get_bullet_speed()
	bullet.set_direction(direction)
	bullet.team_color = team_color
	parent.add_child(bullet)
