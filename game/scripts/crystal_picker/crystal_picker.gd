class_name CrystalPicker
extends Control

signal crystal_picked(crystal_name: String)

func _ready() -> void:
	var button = $Buttons/CrystalButton

	button.pressed.connect(_on_crystal_button_pressed)


func _on_crystal_button_pressed() -> void:
	crystal_picked.emit("crystal_1")
