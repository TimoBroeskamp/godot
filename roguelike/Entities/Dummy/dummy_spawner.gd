extends Node2D

@export var dummy_scene: PackedScene = preload("res://Entities/Dummy/Dummy.tscn")
@export var spawn_delay: float = 3.0

func _ready():
	spawn_dummy()

func spawn_dummy():
	var dummy = dummy_scene.instantiate()
	dummy.position = Vector2(100, 50)  # or a fixed spawn point
	dummy.scale = Vector2(2, 2)
	add_child(dummy)
	dummy.health_component.health_depleted.connect(_on_dummy_depleted)

func _on_dummy_depleted():
	await get_tree().create_timer(spawn_delay).timeout
	spawn_dummy()
