extends PlayerState


func enter(previous_state_path: String, _data := {}) -> void:
	if previous_state_path == GLIDING:
		player.velocity.y = -player.glide_jump_impulse
	else:
		player.velocity.y = -player.jump_impulse
		$Gecko_jump.play()

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("Left", "Right")
	player.velocity.x = player.speed * input_direction_x

	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if player.is_on_floor():
		#Create landing effect
		if is_equal_approx(player.velocity.x, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(RUNNING)
	elif Input.is_action_just_pressed("Down") && Player.canSlam:
		finished.emit(SLAM)
