extends EnemyState

func exit() -> void:
	owner.SetEnemyBodyDamages(true)
	
func enter(_previous_state_path: String, _data := {}) -> void:
	owner.SetEnemyBodyDamages(false)
	
	owner.animate("Stun")
	await get_tree().create_timer(3).timeout
	finished.emit(IDLE)


func physics_update(_delta: float) -> void:
	player.velocity.y += player.gravity * _delta
	player.velocity.x *= 0.95
	player.move_and_slide()
	

