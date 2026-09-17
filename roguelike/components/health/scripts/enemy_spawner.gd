class_name EnemySpawner
extends Node2D

@export var nav_region: NavigationRegion2D
@export var player: Node2D
@export var min_spawn_distance: float = 700.0
@export var pool_size: int = 100

@export var enemy_pool: Array[enemyWeight] = []          # assign your .tres files here
@export var difficulty_curve: Curve                     # x: 0-1 normalized time, y: difficulty value
@export var spawn_budget_curve: Curve                   # x: 0-1 normalized time, y: budget per tick
@export var run_duration: float = 600.0                 # seconds to reach max difficulty
@export var spawn_interval: float = 2.0                 # seconds between spawn ticks

var elapsed: float = 0.0
var current_difficulty: float = 0.0
var pools: Dictionary = {}       # enemyWeight -> Array[Node2D] (per-type pools, since each type differs)
var active_enemies: Array[Node2D] = []
var spawn_timer: float = 0.0

func _ready() -> void:
	for data in enemy_pool:
		var pool_array: Array[Node2D] = []
		for i in pool_size:
			var enemy : Enemy = data.scene.instantiate()
			enemy.died.connect(_on_enemy_died.bind(data))
			_deactivate(enemy)
			add_child(enemy)
			pool_array.append(enemy)
		pools[data] = pool_array

func _process(delta: float) -> void:
	elapsed += delta
	var t : float = clamp(elapsed / run_duration, 0.0, 1.0)
	current_difficulty = difficulty_curve.sample(t)

	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		_on_spawn_tick(t)

func _on_spawn_tick(t: float) -> void:
	var budget := spawn_budget_curve.sample(t)
	var attempts := 0
	while budget > 0.0 and attempts < 20:  # attempt cap, avoid infinite loop if pools exhausted
		attempts += 1
		var data := _pick_enemy(current_difficulty)
		if data == null:
			break
		if not _spawn_from_pool(data):
			continue  # that type's pool was empty, try again / different pick next loop
		budget -= data.difficulty_cost

func _pick_enemy(difficulty: float) -> enemyWeight:
	var valid: Array[enemyWeight] = []
	var total_weight := 0.0
	for data in enemy_pool:
		if difficulty >= data.min_difficulty and difficulty <= data.max_difficulty:
			valid.append(data)
			total_weight += data.spawn_weight

	if valid.is_empty():
		return null

	var roll := randf() * total_weight
	for data in valid:
		roll -= data.spawn_weight
		if roll <= 0.0:
			return data
	return valid[-1]

func _spawn_from_pool(data: enemyWeight) -> bool:
	var pool_array: Array[Node2D] = pools[data]
	if pool_array.is_empty():
		push_warning("Pool exhausted for %s, consider raising pool_size" % data.scene.resource_path)
		return false

	var enemy : Node2D = pool_array.pop_back()
	enemy.global_position = _get_valid_spawn_point()
	_activate(enemy)
	active_enemies.append(enemy)
	return true

func _get_valid_spawn_point() -> Vector2:
	var map_rid := nav_region.get_navigation_map()
	for i in 30:
		var point := NavigationServer2D.map_get_random_point(map_rid, 1, false)
		if point.distance_to(player.global_position) >= min_spawn_distance:
			return point
	push_warning("No valid spawn point found after 30 tries")
	return player.global_position

func _on_enemy_died(enemy: Node2D, data: enemyWeight) -> void:
	active_enemies.erase(enemy)
	_deactivate(enemy)
	pools[data].append(enemy)

func _activate(enemy: Node2D) -> void:
	enemy.visible = true
	enemy.set_physics_process(true)
	enemy.set_process(true)
	enemy.get_node("CollisionShape2D").disabled = false
	if enemy.has_method("reset_state"):
		enemy.reset_state()

func _deactivate(enemy: Node2D) -> void:
	enemy.visible = false
	enemy.set_physics_process(false)
	enemy.set_process(false)
	enemy.get_node("CollisionShape2D").disabled = true
