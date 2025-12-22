extends Area3D

@onready var light: OmniLight3D = $OmniLight3D
@onready var state: String = "normal"


func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group(Constants.BULLETS_GROUP):
		area.queue_free()
		light.light_color = Color(1, 0, 0, 1)
		state = "hit"
