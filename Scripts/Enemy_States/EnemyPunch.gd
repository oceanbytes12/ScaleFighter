extends EnemyState

var attacking = false

func enter(_previous_state_path: String, _data := {}) -> void:
	owner.animate("Punch")
	attacking = true

func start():
	attacking = true
	
func end():
	attacking = false

func physics_update(_delta: float) -> void:
	player.velocity.x = 0
	player.velocity.y = 0
	
	owner.move_and_slide()
	if attacking:
		return
	finished.emit(IDLE)

func exit() -> void:
	pass
