extends PlayerState

#func enter(_previous_state_path: String, _data := {}) -> void:
	#$FS.play()
func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("Left", "Right")
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	player.animate("Walk")
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("Up") && Player.canJump:
		finished.emit(JUMPING)
	elif Input.is_action_just_pressed("Attack"):
		finished.emit(PUNCHING)
	elif is_equal_approx(input_direction_x, 0.0):
		finished.emit(IDLE)
		
