extends PlayerState

var attacking = false

func enter(previous_state_path: String, data := {}) -> void:
	owner.animate("SlamFinish")
	EventBus.on_slam_finish.emit(1)
	
func start():
	attacking = true
	
func end():
	attacking = false

func physics_update(_delta: float) -> void:
	if(!attacking):
		finished.emit(IDLE)

func exit() -> void:
	print("Stopping attack")
