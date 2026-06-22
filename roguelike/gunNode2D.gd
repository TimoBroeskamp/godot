extends Node2D

func _process(delta: float) -> void:
	print(get_global_mouse_position())
	look_at(get_global_mouse_position())
