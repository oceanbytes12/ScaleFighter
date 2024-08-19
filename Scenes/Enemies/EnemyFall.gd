extends EnemyState

var TARGET : CharacterBody2D

var gravity = 1000
var max_velocity = 200
var hasReversed = false

func enter(_previous_state_path: String, _data := {}) -> void:
	owner.animate("Fall") # Change to Jump
	FindTarget()
	hasReversed = false
	
func FindTarget():
	TARGET = Player.mainPlayer
	
func physics_update(delta: float) -> void:
	if owner.is_on_wall and not hasReversed:
		owner.velocity.x = -owner.velocity.x  
		hasReversed = true
		if(owner.velocity.x > 0):
			owner.Flip(false)
		else:
			owner.Flip(true)
		
	#Go down if in air.
	if not owner.is_on_floor():
		owner.velocity.y += gravity * delta
		owner.velocity.y = min(max_velocity, owner.velocity.y)
	else:
		finished.emit(IDLE)
		
	owner.move_and_slide()
