class_name Shooter
extends RefCounted

var bullet_scene: PackedScene = load("res://objects/bullet.tscn")
var bullet_speed: float = 30.0
var shoot_delay: float = 0.3


func shoot(context: ShootingContext) -> void:
	if context.bullet_scene == null:
		context.bullet_scene = bullet_scene

	if context.bullet_speed == 0:
		context.bullet_speed = bullet_speed * context.speed_multiplier

	spawn_bullet(
		context.from_position, context.direction, context.team_color, context.parent, context
	)

	for extra in context.extra_shots:
		var extra_dir = extra.get("direction", context.direction)
		spawn_bullet(context.from_position, extra_dir, context.team_color, context.parent, context)


func spawn_bullet(
	from_position: Vector3,
	direction: Vector3,
	team_color: Color,
	parent: Node,
	context: ShootingContext
) -> void:
	var bullet = context.bullet_scene.instantiate()
	bullet.position = from_position
	bullet.speed = context.bullet_speed
	bullet.set_direction(direction)
	bullet.team_color = team_color
	parent.add_child(bullet)
