class_name Main
extends Node3D

var crystal_picker_scene: PackedScene = load("res://scenes/crystal_picker/crystal_picker.tscn")
var crystal_picker_node: CrystalPicker = null

@onready var hud: HUD = $HUD
@onready var round_manager: RoundManager = $RoundManager


func _ready() -> void:
	round_manager.time_updated.connect(hud.update_time)
	round_manager.round_finished.connect(on_round_finished)
	round_manager.start()


func on_round_finished(winner: Color) -> void:
	print("Round finished! Winner: ", winner)

	var crystal_picker = crystal_picker_scene.instantiate()
	crystal_picker_node = crystal_picker
	crystal_picker.crystal_picked.connect(on_crystal_picked)
	add_child(crystal_picker)


func on_crystal_picked(crystal_name: String) -> void:
	print("Crystal picked: ", crystal_name)
	hud.add_log("Crystal picked: " + crystal_name)
	round_manager.start()
	crystal_picker_node.queue_free()
	crystal_picker_node = null
