class_name CrystalPicker
extends Control

signal crystal_picked(crystal_name: String)
var crystal_button_scene: PackedScene = preload("res://scenes/crystal_picker/crystal_button.tscn")

@onready var result_label: RichTextLabel = $Content/ResultLabel
@onready var buttons: VBoxContainer = $Content/Buttons


func _ready() -> void:
	_spawn_buttons()


func show_result(winner: Player, loser: Player) -> void:
	result_label.bbcode_enabled = true

	if not winner or not loser:
		result_label.text = "Draw!"
		return

	var winner_hex: String = winner.team_color.to_html(false)
	var loser_hex: String = loser.team_color.to_html(false)

	var text: String = (
		"[color=#%s]%s[/color] wins!\n[color=#%s]%s[/color] picks a crystal"
		% [winner_hex, winner_hex.to_upper(), loser_hex, loser_hex.to_upper()]
	)
	result_label.text = text


func _spawn_buttons() -> void:
	for crystal_name in CrystalRegistry.new().get_all_crystals():
		var button = crystal_button_scene.instantiate()
		button.text = crystal_name.capitalize()
		buttons.add_child(button)
		button.pressed.connect(_on_crystal_button_pressed.bind(crystal_name))


func _on_crystal_button_pressed(crystal_name: String) -> void:
	crystal_picked.emit(crystal_name)
