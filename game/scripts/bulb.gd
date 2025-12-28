extends Area3D

signal bulb_hit(new_team_color: Color)

var team_color: Color = Color.WHITE
var _color_initialized := false

@onready var light: OmniLight3D = $OmniLight3D
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	if _color_initialized:
		_apply_color(team_color)
		bulb_hit.emit(team_color)


func set_team_color(color: Color) -> void:
	team_color = color
	_color_initialized = true


func get_color() -> Color:
	return team_color


func _apply_color(color: Color) -> void:
	team_color = color
	light.light_color = color

	var material = mesh_instance.get_active_material(0)
	if material:
		material = material.duplicate()
		material.albedo_color = color
		mesh_instance.set_surface_override_material(0, material)

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group(Constants.BULLETS_GROUP):
		var new_color = area.team_color

		if team_color != new_color:
			_apply_color(new_color)
			bulb_hit.emit(new_color)

		area.queue_free()
