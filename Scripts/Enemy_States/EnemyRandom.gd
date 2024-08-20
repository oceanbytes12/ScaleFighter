extends EnemyState

@export var int_string_pairs: Array[IntString] = []

# Called when the node enters the scene tree for the first time.
func enter(_previous_state_path: String, _data := {}) -> void:
	var random_state = pick_weighted_random()
	
	#Janky AI De-Spamming
	#Makes AI's less likely to spam moves too many times,
	#Even if they like a move.
	
	#If we somehow get a null. Equalize.
	if(random_state == null):
		for pair in int_string_pairs:
			pair.weight = 100
		random_state = pick_weighted_random()
	#Make a idea less desirable if we use it.
	random_state.weight*=0.8
	
	#Make all other ideas more desirable
	for pair in int_string_pairs:
		if(pair != random_state):
			pair.weight *= 1.1
		
	finished.emit(random_state.name)

#Avoid deadlocks
func _process(delta):
	for weight_pair in int_string_pairs:
		weight_pair.weight += delta

# Function to pick a random IntStringPair based on their weights
func pick_weighted_random() -> IntString:
	# Calculate the total weight
	var total_weight = 0
	for pair in int_string_pairs:
		total_weight += pair.weight
	# Generate a random value between 0 and the total weight
	var random_value = randi_range(0, total_weight - 1)
	# Iterate through the pairs and subtract their weights from the random value
	for pair in int_string_pairs:
		random_value -= pair.weight
		if random_value < 0:
			return pair
	# Fallback in case no pair is selected (shouldn't happen)
	return null
