extends Node3D

var velocity: Vector3 = Vector3.ZERO
var speed: float = 10.0
var lifetime: float = 3.0
var gravity: float = 3
var team_color: Color = Color.WHITE

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var light: OmniLight3D = $OmniLight3D


func _ready():
	_apply_team_color()
	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _process(delta):
	position += velocity * speed * delta
	velocity.y -= gravity * delta


func set_direction(direction: Vector3):
	velocity = direction.normalized()


func _apply_team_color() -> void:
	if mesh_instance:
		var material = StandardMaterial3D.new()
		material.albedo_color = team_color
		material.emission_enabled = true
		material.emission = team_color
		material.emission_energy_multiplier = 2.0
		mesh_instance.material_override = material

	if light:
		light.light_color = team_color
