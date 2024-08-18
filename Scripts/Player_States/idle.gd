extends PlayerState


func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.x = 0.0
	owner.animate("Idle")


func physics_update(_delta: float) -> void:
	player.velocity.y += player.gravity * _delta
	player.move_and_slide()

	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("Up"):
		finished.emit(JUMPING)
	elif Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
		finished.emit(RUNNING)
	elif Input.is_action_pressed("Attack"):
		finished.emit(PUNCHING)
