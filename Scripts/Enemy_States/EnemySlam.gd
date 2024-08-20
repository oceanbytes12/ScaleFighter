extends EnemyState

func enter(previous_state_path: String, data := {}) -> void:
	owner.animate("AirSlam") 
	owner.velocity.y = 0
	owner.SetEnemyBodyDamages(true)
	
func physics_update(_delta: float) -> void:
	owner.velocity.x = 0
	owner.velocity.y = owner.velocity.y + 1000*_delta
	owner.move_and_slide()
	
	if owner.is_on_floor():
		finished.emit(SLAMFINISH)
		$Enemy_slam.play()
func exit() -> void:
	pass

	
