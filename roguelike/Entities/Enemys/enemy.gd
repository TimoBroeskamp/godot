class_name Enemy
extends CharacterBody2D

signal died(enemy: Node2D)

func reset_state() -> void:
	pass  # overridden by subclasses
