extends Node2D

@export var target: Node2D  # assign the Player node in the Inspector

func _ready() -> void:
	target = get_node("../Player")

func _physics_process(delta: float) -> void:
	if target:
		global_position = target.global_position + Vector2(0, -14)
	look_at(get_global_mouse_position())

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		$Gun.shoot()
