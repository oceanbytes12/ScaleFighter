extends EnemyState

var currenttime=0
var maxtime=1

func enter(previous_state_path: String, data := {}) -> void:
	owner.animate("Idle")
	currenttime = maxtime

func update(_delta: float) -> void:
	currenttime-= _delta
	if(currenttime<=0):
		finished.emit(CHASE)
	
func physics_update(_delta: float) -> void:
	player.velocity.y += player.gravity * _delta
	player.move_and_slide()
