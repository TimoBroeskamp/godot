extends CharacterBody2D

@onready var health_component: Stats = $Stats
@onready var health_bar = $Healthbar

func _ready():
	health_bar.init_health(health_component.max_health)
	
	health_component.health_changed.connect(func(_diff):
		health_bar.health = health_component.health
		)
	
	health_component.max_health_changed.connect(func(_diff):
		health_bar.max_value = health_component.max_health
		health_bar.damage_bar.max_value = health_component.max_health
	)
	
func _on_health_health_depleted() -> void:
	queue_free()

func respawn() -> void:
	pass
