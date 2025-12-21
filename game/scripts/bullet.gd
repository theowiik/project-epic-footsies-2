extends Node3D

var velocity: Vector3 = Vector3.ZERO
var speed: float = 500.0
var lifetime: float = 3.0


func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _process(delta):
	position += velocity * speed * delta


func set_direction(direction: Vector3):
	velocity = direction.normalized()
