extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.animate("Hurt")
	player.Blink()
	await get_tree().create_timer(0.5).timeout
	finished.emit(IDLE)


func physics_update(_delta: float) -> void:
	player.velocity.y += player.gravity * _delta
	player.velocity.x *= 0.95
	player.move_and_slide()
	
