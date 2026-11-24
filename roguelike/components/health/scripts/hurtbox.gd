class_name HurtBox
extends Area2D

@export var health: Stats

func _ready():
	connect("area_entered", _on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HitBox:
		var hitbox := area as HitBox
		health.health -= hitbox.damage
