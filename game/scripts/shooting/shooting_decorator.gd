class_name ShooterDecorator
extends ShooterInterface

var wrapped_shooter: ShooterInterface
var config: ShooterDecoratorConfig


func _init(shooter: ShooterInterface, decorator_config: ShooterDecoratorConfig = null):
	wrapped_shooter = shooter
	config = decorator_config


func get_shoot_delay() -> float:
	return wrapped_shooter.get_shoot_delay()


func shoot(context: ShootingContext) -> void:
	wrapped_shooter.shoot(context)
