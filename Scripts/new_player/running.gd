extends PlayerState


func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("Left", "Right")
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("Up"):
		finished.emit(JUMPING)
	elif Input.is_action_just_pressed("Attack"):
		finished.emit(PUNCHING)
	elif is_equal_approx(input_direction_x, 0.0):
		finished.emit(IDLE)
		
