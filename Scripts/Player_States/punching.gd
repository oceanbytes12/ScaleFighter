extends PlayerState

var attacking = false

func enter(previous_state_path: String, data := {}) -> void:
	owner.animate("Punch")
	
	
func start():
	attacking = true
	$Punch_woosh.play()
	
func end():
	attacking = false

func physics_update(_delta: float) -> void:
	player.velocity.x = 0
	player.move_and_slide()
	
	if attacking:
		return
	
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif not Input.is_action_pressed("Attack"):
		finished.emit(IDLE)
	elif Input.is_action_just_pressed("Up"):
		finished.emit(JUMPING)

func exit() -> void:
	pass
