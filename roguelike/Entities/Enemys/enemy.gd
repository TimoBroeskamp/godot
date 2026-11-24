class_name Enemy
extends CharacterBody2D

signal died(enemy: Node2D)

@onready var navigation = $Navigation
@onready var hitbox: HitBox = $HitBox
@onready var stats: Stats = $Stats
@onready var health_bar = $Healthbar

func _ready():
	health_bar.init_health(stats.max_health)
	
	stats.health_changed.connect(func(_diff):
		health_bar.health = stats.health
		)
	
	stats.max_health_changed.connect(func(_diff):
		health_bar.max_value = stats.max_health
		health_bar.damage_bar.max_value = stats.max_health
	)
	
	hitbox.damage = stats.damage
	stats.health_depleted.connect(_on_death)

func _on_death() -> void:
	died.emit(self)

func _physics_process(_delta: float) -> void:
	move_to_player()
	move_and_slide()

# Movement
func move_to_player() -> void:
	velocity = navigation.move_direction * stats.movement_speed

func reset_state() -> void:
	stats.health = stats.max_health
	# reset anim state, velocity, current nav target, any timers here too
	velocity = Vector2.ZERO
