class_name HitBox
extends Area2D

var damage: float = 1

func set_damage(value: float):
	damage = value


func get_damage() -> float:
	return damage
