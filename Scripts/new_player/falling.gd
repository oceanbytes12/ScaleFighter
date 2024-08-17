extends PlayerState


func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("Left", "Right")
	player.velocity.x = player.speed * input_direction_x

	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if Input.is_action_just_pressed("glide"):
		finished.emit(GLIDING)
	if Input.is_action_just_pressed("Attack"):
		finished.emit(AIRPUNCH)
	elif player.is_on_floor():
		#Create landing effect
		if is_equal_approx(player.velocity.x, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(RUNNING)
