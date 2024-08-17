extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	owner.animate("AirPunch")
	player.velocity.y = max(player.velocity.y, 0.0)


func physics_update(_delta: float) -> void:
	var input_direction_x := Input.get_axis("Left", "Right")
	player.velocity.x += input_direction_x * player.glide_acceleration * _delta
	player.velocity.x = min(player.velocity.x, player.glide_max_speed)
	player.velocity.y = 3000*_delta
	player.move_and_slide()


	if not Input.is_action_pressed("Attack"):
		finished.emit(FALLING)
	elif player.get_slide_collision_count() > 0:
		if Input.is_action_pressed("Attack"):
			finished.emit(PUNCHING)
		elif input_direction_x != 0.0:
			finished.emit(RUNNING)
		else:
			finished.emit(IDLE)

	elif Input.is_action_just_pressed("Up"):
		finished.emit(JUMPING)



func exit() -> void:
	print("Stopping attack")

	
