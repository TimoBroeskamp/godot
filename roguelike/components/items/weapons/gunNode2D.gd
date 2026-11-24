extends Node2D

@onready var target: Node2D = get_node("../Player")

var can_shoot: bool = true
var shoot_timer: float = 0.0

func _physics_process(delta: float) -> void:
	if target:
		global_position = target.global_position + Vector2(0, -14)
	look_at(get_global_mouse_position())
	
	if shoot_timer > 0.0:
		shoot_timer -= delta
		if shoot_timer <= 0.0:
			can_shoot = true

	if Input.is_action_pressed("mouse_left") and can_shoot:
		$Gun.shoot()
		can_shoot = false
		shoot_timer = 1.0 / target.stats.attack_speed
