class_name FollowCamera
extends Camera3D

@export var smoothing_speed: float = 5.0
var follow: Array[Node3D] = []
var offset: Vector3 = Vector3(0, 0, 25)


func _ready() -> void:
	var players: Array[Node] = get_tree().get_nodes_in_group("players")

	for player in players:
		follow.append(player as Node3D)


func _physics_process(delta: float) -> void:
	if follow.is_empty():
		return

	var avg_position: Vector3 = Vector3.ZERO
	for node in follow:
		avg_position += node.global_position
	avg_position /= follow.size()

	var target_position: Vector3 = avg_position + offset
	global_position = global_position.lerp(target_position, 1.0 - exp(-smoothing_speed * delta))
