class_name ShootingContext
extends RefCounted

var from_position: Vector3
var direction: Vector3
var team_color: Color
var parent: Node
var bullet_speed: float = 0.0
var bullet_scene: PackedScene = null
var speed_multiplier: float = 1.0
var extra_shots: Array[Dictionary] = []


func _init(pos: Vector3, dir: Vector3, color: Color, p: Node):
	from_position = pos
	direction = dir
	team_color = color
	parent = p
