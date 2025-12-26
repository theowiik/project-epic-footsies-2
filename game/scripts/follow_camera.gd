class_name FollowCamera
extends Camera3D

@export var smoothing_speed: float = 5.0
@export var zoom_smoothing_speed: float = 3.0
@export var min_zoom: float = 30.0
@export var padding: float = 8.0

var follow: Array[Node3D] = []
var base_offset: Vector3 = Vector3(0, 0, 0)
var current_zoom: float = 10.0


func _ready() -> void:
	var players: Array[Node] = get_tree().get_nodes_in_group("players")

	for player in players:
		follow.append(player as Node3D)

	current_zoom = min_zoom


func _process(delta: float) -> void:
	if follow.is_empty():
		return

	var avg_position: Vector3 = Vector3.ZERO
	for node in follow:
		avg_position += node.global_position
	avg_position /= follow.size()

	var target_zoom: float = _calculate_zoom_to_fit()

	current_zoom = lerpf(current_zoom, target_zoom, 1.0 - exp(-zoom_smoothing_speed * delta))

	var target_position: Vector3 = avg_position + base_offset + Vector3(0, 0, current_zoom)
	global_position = global_position.lerp(target_position, 1.0 - exp(-smoothing_speed * delta))


func _calculate_zoom_to_fit() -> float:
	if follow.size() <= 1:
		return min_zoom

	var min_bounds: Vector3 = follow[0].global_position
	var max_bounds: Vector3 = follow[0].global_position

	for node in follow:
		var pos: Vector3 = node.global_position
		min_bounds.x = min(min_bounds.x, pos.x)
		min_bounds.y = min(min_bounds.y, pos.y)
		max_bounds.x = max(max_bounds.x, pos.x)
		max_bounds.y = max(max_bounds.y, pos.y)

	var spread_x: float = (max_bounds.x - min_bounds.x) + padding * 2
	var spread_y: float = (max_bounds.y - min_bounds.y) + padding * 2

	var fov_rad: float = deg_to_rad(fov)
	var aspect: float = (
		get_viewport().get_visible_rect().size.x / get_viewport().get_visible_rect().size.y
	)

	var dist_for_width: float = (spread_x / 2.0) / (tan(fov_rad / 2.0) * aspect)
	var dist_for_height: float = (spread_y / 2.0) / tan(fov_rad / 2.0)

	var required_zoom: float = max(dist_for_width, dist_for_height)

	return maxf(required_zoom, min_zoom)
