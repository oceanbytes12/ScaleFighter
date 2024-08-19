extends EnemyState

var attacking = false

func enter(_previous_state_path: String, _data := {}) -> void:
	print("Entering PUNCH state")
	owner.animate("Punch")
	attacking = true

func start():
	attacking = true
	
func end():
	attacking = false

func physics_update(_delta: float) -> void:
	player.velocity.x = 0
	owner.move_and_slide()
	if attacking:
		return
	finished.emit(IDLE)

func exit() -> void:
	pass
