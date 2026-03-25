extends CharacterBody2D

var SPEED : int = 350

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
	
# Movement
func get_input() -> void:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * SPEED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		get_node("Gun").shoot()
