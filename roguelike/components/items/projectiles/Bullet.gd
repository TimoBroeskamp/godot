extends Area2D

@export var speed :int = 400
var target_position: Vector2
var despawn_time :int = 2
	
func _physics_process(delta: float) -> void:
	position += target_position * speed * delta
	
func _ready() -> void:
	await get_tree().create_timer(despawn_time).timeout 
	queue_free()
