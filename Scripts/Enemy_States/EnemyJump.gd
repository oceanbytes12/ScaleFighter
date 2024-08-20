extends EnemyState

var TARGET : CharacterBody2D
const JUMP_Y_SPEED = -400.0
var JUMP_X_SPEED = 120
var max_velocity = 200
var gravity = 1000
var isJumping = false
var hasReversed = false

func enter(_previous_state_path: String, _data := {}) -> void:
	owner.animate("Jump") # Change to Jump
	FindTarget()
	$Enemy_jump.play()        
	isJumping = false
	hasReversed = false
	#Jump towards target
	var target_vector = TARGET.global_position - owner.global_position
	#Jump in direction of player a set amount
	if(target_vector.x > 0):
		owner.Flip(false)
		owner.velocity.x = JUMP_X_SPEED
		owner.velocity.y = JUMP_Y_SPEED
	else:
		owner.Flip(true)
		owner.velocity.x = -JUMP_X_SPEED
		owner.velocity.y = JUMP_Y_SPEED

func FindTarget():
	TARGET = Player.mainPlayer

func physics_update(delta: float) -> void:
	if(!TARGET):
		finished.emit(IDLE)
		return
	
	if owner.is_on_wall and not hasReversed:
		$Enemy_wall.play()
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
		
	#If go down, fall
	if(owner.velocity.y > 3):
		finished.emit(FALL)
	
	owner.move_and_slide()
