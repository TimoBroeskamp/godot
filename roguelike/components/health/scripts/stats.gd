class_name Stats
extends Node

signal max_health_changed(diff: int)
signal health_changed(diff: int)
signal health_depleted

@export var max_health: float = 3 : set = set_max_health, get = get_max_health
@export var immortality: bool = false : set = set_immortality, get = get_immortality
@export var damage: float = 1 : set = set_damage, get = get_damage
@export var movement_speed: float = 100 : set = set_movement_speed, get = get_movement_speed
@export var attack_speed: float = 1 : set = set_attack_speed, get = get_attack_speed

@onready var health: float = max_health : set = set_health, get = get_health

func set_max_health(value: float):
	var clamped_value = 1.0 if value <= 0.0 else value
	
	if not clamped_value == max_health:
		var difference = clamped_value - max_health
		max_health = clamped_value
		max_health_changed.emit(difference)
		
		if health > max_health:
			health = max_health

func get_max_health() -> float:
	return max_health

func set_immortality(value: bool):
	immortality = value

func get_immortality() -> bool:
	return immortality

func set_health(value: float):
	if value < health and immortality:
		return
	
	var clamped_value = clampf(value, 0.0, max_health)
	
	if clamped_value != health:
		var difference = clamped_value - health
		health = clamped_value
		health_changed.emit(difference)
		
		if health == 0:
			health_depleted.emit()

func get_health():
	return health


func set_damage(value: float):
	damage = max(0.0, value)

func get_damage() -> float:
	return damage

func set_movement_speed(value: float):
	movement_speed = max(0.0, value)

func get_movement_speed() -> float:
	return movement_speed

func set_attack_speed(value: float):
	attack_speed = max(0.0, value)

func get_attack_speed() -> float:
	return attack_speed
