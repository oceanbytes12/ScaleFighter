extends EnemyState

var current_time
var max_time = 3

func exit() -> void:
	owner.SetEnemyBodyDamages(true)
	
func enter(_previous_state_path: String, _data := {}) -> void:
	owner.SetEnemyBodyDamages(false)
	owner.animate("Stun")
	current_time = max_time

func update(_delta: float) -> void:
	current_time-=_delta
	if(current_time <= 0):
		finished.emit(IDLE)
		
func physics_update(_delta: float) -> void:
	player.velocity.y += player.gravity * _delta
	player.velocity.x *= 0.95
	player.move_and_slide()
	

