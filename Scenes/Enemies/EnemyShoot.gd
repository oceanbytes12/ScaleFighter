extends EnemyState

var attacking = false

func enter(previous_state_path: String, data := {}) -> void:
	owner.animate("Shoot")


func start():
	attacking = true
	
func end():
	attacking = false

func physics_update(delta: float) -> void:
	player.velocity.x = 0
	owner.move_and_slide()
	if attacking:
		return
	finished.emit(IDLE)

func exit() -> void:
	pass
