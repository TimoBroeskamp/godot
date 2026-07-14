class_name Stats
extends Node

signal max_health_changed(diff: int)
signal health_changed(diff: int)
signal health_depleted
signal damage_changed(diff: float)
signal movement_speed_changed(diff: float)
signal attack_speed_changed(diff: float)

@export var max_health: float = 3 : set = set_max_health, get = get_max_health
@export var immortality: bool = false : set = set_immortality, get = get_immortality
@export var damage: float = 1 : set = set_damage, get = get_damage
@export var movement_speed: float = 100 : set = set_movement_speed, get = get_movement_speed
@export var attack_speed: float = 1 : set = set_attack_speed, get = get_attack_speed

var immortality_timer: Timer = null

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

func set_temporary_immortality(time: float):
	if immortality_timer == null:
		immortality_timer = Timer.new()
		immortality_timer.one_shot = true
		add_child(immortality_timer)
	
	if immortality_timer.timeout.is_connected(set_immortality):
		immortality_timer.timeout.disconnect(set_immortality)
	
	immortality_timer.wait_time = time
	immortality_timer.timeout.connect(set_immortality.bind(false))
	immortality = true
	immortality_timer.start()

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
	var clamped = max(0.0, value)
	if clamped != damage:
		var diff = clamped - damage
		damage = clamped
		damage_changed.emit(diff)

func get_damage() -> float:
	return damage

func set_movement_speed(value: float):
	var clamped = max(0.0, value)
	if clamped != movement_speed:
		var diff = clamped - movement_speed
		movement_speed = clamped
		movement_speed_changed.emit(diff)

func get_movement_speed() -> float:
	return movement_speed

func set_attack_speed(value: float):
	var clamped = max(0.0, value)
	if clamped != attack_speed:
		var diff = clamped - attack_speed
		attack_speed = clamped
		attack_speed_changed.emit(diff)

func get_attack_speed() -> float:
	return attack_speed
