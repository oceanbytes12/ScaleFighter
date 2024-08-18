extends EnemyState


func enter(previous_state_path: String, data := {}) -> void:
	owner.animate("Stun")
	await get_tree().create_timer(5).timeout
	finished.emit(IDLE)


func physics_update(_delta: float) -> void:
	player.velocity.y += player.gravity * _delta
	player.velocity.x *= 0.95
	player.move_and_slide()
	

