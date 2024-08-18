extends EnemyState

var attacking = false

func enter(previous_state_path: String, data := {}) -> void:
	owner.animate("Punch")
	attacking = true
	print("PUNCHING0")

func start():
	print("Punching")
	attacking = true
	
func end():
	print("Punching2")
	attacking = false

func physics_update(delta: float) -> void:
	player.velocity.x = 0
	owner.move_and_slide()
	if attacking:
		return
	finished.emit(IDLE)

func exit() -> void:
	#print("Stopping attack")
	pass
