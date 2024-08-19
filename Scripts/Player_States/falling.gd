extends PlayerState

@onready var land_effect = preload("res://scenes/Player/land_effect.tscn")

func play_effect(effect):
	var new_effect = effect.instantiate()
	new_effect.global_position = owner.Feet.global_position
	var root = get_tree().current_scene
	root.add_child(new_effect)

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("Left", "Right")
	player.velocity.x = player.speed * input_direction_x

	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if Input.is_action_just_pressed("Down") && Player.canSlam:
		finished.emit(SLAM)
	elif Input.is_action_just_pressed("Attack"):
		finished.emit(AIRPUNCH)
	elif player.is_on_floor():
		play_effect(land_effect)
		#Create landing effect
		if is_equal_approx(player.velocity.x, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(RUNNING)
