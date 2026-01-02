extends Area3D

const BULB_SCENE: PackedScene = preload("res://objects/bulb.tscn")

var team: Team = Team.white()
var velocity: Vector3 = Vector3.ZERO
var speed: float = 10.0
var lifetime: float = 3.0
var _gravity: float = 3
var _material: StandardMaterial3D

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var light: OmniLight3D = $OmniLight3D


func _ready():
	# Create a dedicated material for this bullet instance
	_material = StandardMaterial3D.new()
	_material.emission_enabled = true
	_material.emission_energy_multiplier = 2.0
	mesh_instance.material_override = _material

	_apply_team_color()
	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _physics_process(delta):
	position += velocity * speed * delta
	velocity.y -= _gravity * delta


func set_direction(direction: Vector3):
	velocity = direction.normalized()


func _apply_team_color() -> void:
	if _material:
		_material.albedo_color = team.color
		_material.emission = team.color

	if light:
		light.light_color = team.color


func _on_body_entered(_body: Node3D) -> void:
	var bulb = BULB_SCENE.instantiate()
	bulb.set_team(team)
	bulb.global_position = global_position
	get_tree().current_scene.add_child(bulb)
	queue_free()
