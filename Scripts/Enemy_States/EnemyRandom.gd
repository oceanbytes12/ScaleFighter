extends EnemyState

@export var possible_states: Array[String] = []

# Called when the node enters the scene tree for the first time.
func enter(previous_state_path: String, data := {}) -> void:
	var random_state = get_random_state()
	finished.emit(random_state)

func get_random_state():
	var random_num = randi() % len(possible_states) - 1
	var random_state = possible_states[random_num]
	return random_state
