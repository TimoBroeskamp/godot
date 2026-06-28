extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@export var nav_agent: NavigationAgent2D

var move_direction := Vector2.ZERO

func _ready():
	nav_agent.path_desired_distance = 4
	nav_agent.target_desired_distance = 4

func _physics_process(_delta):
	if player == null:
		return
	
	nav_agent.target_position = player.global_position
	
	if nav_agent.is_navigation_finished():
		move_direction = Vector2.ZERO
		return
	
	move_direction = to_local(nav_agent.get_next_path_position()).normalized()
