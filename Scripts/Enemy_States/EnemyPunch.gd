extends EnemyState

var attacking = false

func enter(_previous_state_path: String, _data := {}) -> void:
	owner.animate("Punch")
	attacking = true

func start():
	attacking = true
	$Enemy_punch_woosh.play()
	#$Squirrel_punch_woosh.play()
	#$Gorilla_punch_woosh.play()          
func end():
	attacking = false

func physics_update(_delta: float) -> void:
	owner.velocity.x = 0
	owner.velocity.y = 0
	
	owner.move_and_slide()
	if attacking:
		return
	finished.emit(IDLE)

func exit() -> void:
	pass
