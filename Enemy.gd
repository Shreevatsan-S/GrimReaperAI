extends KinematicBody2D

export(int) var SPEED: int = 40
export(float) var epsilon: float = 0.1 # Exploration rate
export(float) var alpha: float = 0.1 # Learning rate
export(float) var gamma: float = 0.9 # Discount factor

var velocity: Vector2 = Vector2.ZERO
var path: Array = []  # Contains destination positions
var levelNavigation: Navigation2D = null
var player = null
var player_spotted: bool = true
var elapsed_time = 0.0
var max_time = 10.0

var q_values = {}
var current_state = Vector2.ZERO

# Define actions
enum Action {
	NOOP, LEFT, RIGHT, UP, DOWN
}

onready var line2d = $Line2D
onready var los = $LineOfSight

func _ready():
	if Global.mode == "hard":
		SPEED = 60
	yield(get_tree(), "idle_frame")
	position = Vector2(0, 0)
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		levelNavigation = tree.get_nodes_in_group("LevelNavigation")[0]
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0]
	
	initialize_q_values()

func _physics_process(delta):
	timer(delta)
	line2d.global_position = Vector2.ZERO
	if player:
		los.look_at(player.global_position)
		check_player_in_detection()
		if player_spotted:
			generate_path()
			navigate()
		move()
		# Update state-action pair using Q-learning
		update_q_values(delta)

func check_player_in_detection() -> bool:
	var collider = los.get_collider()
	if collider and collider.is_in_group("Player"):
		player_spotted = true
		yield(get_tree().create_timer(1.5), "timeout")
		get_tree().change_scene("res://GameOver.tscn")
		return true
	return false

func navigate():
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * SPEED
		# If reached the destination, remove this point from path array
		if global_position == path[0]:
			path.pop_front()

func generate_path():
	if levelNavigation != null and player != null:
		path = levelNavigation.get_simple_path(global_position, player.global_position, false)
		if(Global.mode == "easy"):
			line2d.points = path

func move():
	velocity = move_and_slide(velocity)

func timer(delta):
	elapsed_time += delta
	if elapsed_time > max_time:
		get_tree().change_scene("res://Victory.tscn")

func reward() -> float:
	var reward = 0.0
	if elapsed_time < max_time and elapsed_time > 7.0:
		if global_position == player.global_position:
			reward += 50  # Reward for reaching the player
		else:
			reward -= 10  # Penalty for moving away from the goal
	return reward

# Initialize Q-values for each state-action pair
func initialize_q_values():
	var actions = [Action.NOOP, Action.LEFT, Action.RIGHT, Action.UP, Action.DOWN]
	for x in range(-100, 100):  # Grid X range
		for y in range(-100, 100):  # Grid Y range
			var state = Vector2(x, y)
			q_values[state] = {}
			for action in actions:
				q_values[state][action] = 0.0  # Initialize all Q-values to 0

func update_q_values(delta):
	var current_action = choose_action(current_state)
	var current_reward = reward()
	var next_state = get_next_state(current_action)
	var next_action = choose_action(next_state)

	var future_q = q_values[next_state][next_action]
	var current_q = q_values[current_state][current_action]
	q_values[current_state][current_action] = current_q + alpha * (current_reward + gamma * future_q - current_q)

	current_state = next_state

func choose_action(state: Vector2) -> int:
	var random_value = rand_range(0.0, 1.0)
	if random_value < epsilon:
		# Exploration: Choose a random action
		return randi() % 5 
	else:
		var max_q = -1e6
		var best_action = Action.NOOP
		for action in q_values[state].keys():
			if q_values[state][action] > max_q:
				max_q = q_values[state][action]
				best_action = action
		return best_action

func get_next_state(action: int) -> Vector2:
	match action:
		Action.NOOP:
			return current_state 
		Action.LEFT:
			return current_state + Vector2(-1, 0)
		Action.RIGHT:
			return current_state + Vector2(1, 0)
		Action.UP:
			return current_state + Vector2(0, -1)
		Action.DOWN:
			return current_state + Vector2(0, 1)
	return current_state
