extends Area3D

signal bulb_hit(new_team_color: Color)

@onready var light: OmniLight3D = $OmniLight3D


func get_color() -> Color:
	return $OmniLight3D.light_color


func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group(Constants.BULLETS_GROUP):
		var old_color = light.light_color
		var new_color = area.team_color

		# Only process if the color actually changed
		if old_color != new_color:
			light.light_color = new_color
			bulb_hit.emit(new_color)

		area.queue_free()
