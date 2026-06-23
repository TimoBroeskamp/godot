extends Sprite2D

@onready var marker_2d: Marker2D = $Marker2D
const BULLET = preload("res://components/items/projectiles/Bullet.tscn")


func shoot() -> void:
	var new_bullet = BULLET.instantiate()
	new_bullet.position = marker_2d.global_position
	new_bullet.target_position = (get_global_mouse_position() - marker_2d.global_position).normalized()
	GlobalData.World.add_child(new_bullet)
