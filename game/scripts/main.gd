class_name Main
extends Node3D

var crystal_picker_scene: PackedScene = load("res://scenes/crystal_picker/crystal_picker.tscn")
var crystal_picker_node: CrystalPicker = null
var current_loser: Player = null

@onready var hud: HUD = $HUD
@onready var round_manager: RoundManager = $RoundManager


func _ready() -> void:
	round_manager.time_updated.connect(hud.update_time)
	round_manager.scores_updated.connect(hud.update_scores)
	round_manager.round_finished.connect(on_round_finished)
	round_manager.start()


func on_round_finished(winner: Player, loser: Player) -> void:
	current_loser = loser

	var crystal_picker = crystal_picker_scene.instantiate()
	crystal_picker_node = crystal_picker
	crystal_picker.crystal_picked.connect(on_crystal_picked)
	add_child(crystal_picker)
	crystal_picker.show_result(winner, loser)
	process_mode = Node.PROCESS_MODE_DISABLED


func on_crystal_picked(crystal_name: String) -> void:
	hud.add_log("Crystal picked: " + crystal_name)

	if current_loser:
		current_loser.apply_crystal(crystal_name)

	round_manager.start()
	crystal_picker_node.queue_free()
	crystal_picker_node = null
	current_loser = null
	process_mode = Node.PROCESS_MODE_INHERIT


func _on_ob_body_entered(body: Node3D) -> void:
	if body.is_in_group(Constants.PLAYERS_GROUP):
		body.global_position = Vector3(0, 0, 0)
