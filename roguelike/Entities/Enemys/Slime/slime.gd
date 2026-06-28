extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var navigation = $Navigation
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

func move_to_player() -> void:
	velocity = navigation.move_direction * stats.movement_speed
