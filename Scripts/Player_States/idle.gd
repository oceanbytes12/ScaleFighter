extends PlayerState


func enter(_previous_state_path: String, _data := {}) -> void:
	player.velocity.x = 0.0
	owner.animate("Idle")


func physics_update(_delta: float) -> void:

	player.velocity.y += player.gravity * _delta
	player.move_and_slide()
	
	if(!LevelBase.FightStarted):
		return
		
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("Up") && Player.canJump:
		finished.emit(JUMPING)
	elif Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
		finished.emit(RUNNING)
	elif Input.is_action_pressed("Attack"):
		finished.emit(PUNCHING)
