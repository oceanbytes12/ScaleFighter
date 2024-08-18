extends PlayerState

@export var blinkAnimator : AnimationPlayer

func enter(previous_state_path: String, data := {}) -> void:
	blinkAnimator.play("Blink")
	await get_tree().create_timer(0.5).timeout
	finished.emit(IDLE)


func physics_update(_delta: float) -> void:
	player.velocity.y += player.gravity * _delta
	player.velocity.x *= 0.95
	player.move_and_slide()
	
