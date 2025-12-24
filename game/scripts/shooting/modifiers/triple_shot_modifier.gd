class_name TripleShotModifier
extends ShootingModifier

var spread_angle: float = 15.0


func _init(angle: float = 15.0):
	spread_angle = angle


func modify(context: ShootingContext) -> void:
	var left_dir = context.direction.rotated(Vector3.FORWARD, deg_to_rad(spread_angle))
	context.extra_shots.append({"direction": left_dir})

	var right_dir = context.direction.rotated(Vector3.FORWARD, -deg_to_rad(spread_angle))
	context.extra_shots.append({"direction": right_dir})
