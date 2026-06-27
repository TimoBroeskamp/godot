extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var hitbox: HitBox = $HitBox
@onready var stats: Stats = $Stats
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
	
	hitbox.damage = stats.damage
	stats.health_depleted.connect(_on_death)
	
func _on_health_health_depleted() -> void:
	queue_free()

func respawn() -> void:
	pass

func _on_death() -> void:
	queue_free()


func _physics_process(delta: float) -> void:
	move_to_player()
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


func move_to_player() -> void:
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * stats.movement_speed
	
	var input_direction = get_8way_direction(direction)
