extends Camera3D
class_name FollowCamera

var follow: Array[Node3D] = []
var offset: Vector3 = Vector3(0, 3, 18)
@export var smoothing_speed: float = 5.0


func _ready() -> void:
	var players: Array[Node] = get_tree().get_nodes_in_group("players")

	for player in players:
		follow.append(player as Node3D)


func _process(delta: float) -> void:
	if follow.is_empty():
		return

	var target_position: Vector3 = follow[0].global_position + offset
	global_position = global_position.lerp(target_position, 1.0 - exp(-smoothing_speed * delta))
