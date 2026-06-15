extends CharacterBody2D

var SPEED : int = 250

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: HitBox = $HitBox
@onready var stats: Stats = $Stats

func _ready() -> void:
	hitbox.damage = stats.damage

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
	
# Movement

#calculation to turn for example top-left movement into (1, 1) Voctor
func get_8way_direction(dir: Vector2) -> Vector2:
	if dir.length() < 0.2:  # dead zone
		return Vector2.ZERO
	var angle = dir.angle()  # radians, -PI to PI
	# Snap to nearest 45° increment
	var input_snapped: int = round(angle / (PI / 4)) * (PI / 4)
	return Vector2(cos(input_snapped), sin(input_snapped)).snapped(Vector2.ONE)
	


func get_input() -> void:
	var raw_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = raw_direction * SPEED
	
	#get clear values for the animations
	var input_direction = get_8way_direction(raw_direction)
	
	# animations
	if raw_direction == Vector2(0, 0):
		animated_sprite_2d.play("idle_right")
	elif input_direction == Vector2(0, 1):
		animated_sprite_2d.play("walk_down")
	elif input_direction == Vector2(0, -1):
		animated_sprite_2d.play("walk_up")
	elif input_direction == Vector2(1, 0):
		animated_sprite_2d.play("walk_right")
	elif input_direction == Vector2(-1, 0):
		animated_sprite_2d.play("walk_left")
	elif input_direction == Vector2(1, 1):
		animated_sprite_2d.play("walk_down_right")
	elif input_direction == Vector2(-1, -1):
		animated_sprite_2d.play("walk_up_left")
	elif input_direction == Vector2(-1, 1):
		animated_sprite_2d.play("walk_down_left")
	elif input_direction == Vector2(1, -1):
		animated_sprite_2d.play("walk_up_right")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		get_node("Gun").shoot()
