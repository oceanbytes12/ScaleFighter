extends EnemyState

var currenttime=0
var maxtime=1

@export var nextState = ""

func enter(_previous_state_path: String, _data := {}) -> void:
	owner.animate("Idle")
	currenttime = maxtime
	owner.velocity.x = 0
	owner.velocity.y = 0

func update(_delta: float) -> void:
	currenttime-= _delta
	if(currenttime<=0):
		finished.emit(nextState)
	
func physics_update(_delta: float) -> void:
	player.velocity.y += player.gravity * _delta
	player.move_and_slide()
