extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	owner.animate("AirSlam")
	player.velocity.y = 0


func physics_update(_delta: float) -> void:
	#var input_direction_x := Input.get_axis("Left", "Right")
	#player.velocity.x += input_direction_x * player.slam_speed * _delta
	#player.velocity.x = min(player.velocity.x, player.max_slam_speed)
	player.velocity.y = player.velocity.y + 1000*_delta
	player.move_and_slide()
	if player.is_on_floor():
		finished.emit(SLAMFINISH)

func exit() -> void:
	pass

	
