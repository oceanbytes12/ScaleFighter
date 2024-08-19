extends EnemyState

var TARGET : CharacterBody2D
const JUMP_Y_SPEED = -125.0
var JUMP_X_SPEED = 800
var max_velocity = 200
var gravity = 5
var isJumping = false
var hasReversed = false
var time_in_state = 0
var required_time = 1.3
var current_wall_pause_time = 0
var max_wall_pause_time = 1
var range = 50
var num_jumps_used = 0
var max_jumps = 3
var check_range = 6

func enter(_previous_state_path: String, _data := {}) -> void:
	num_jumps_used = 0
	time_in_state = 0
	current_wall_pause_time = 0
	print("Entered JUMP state")
	owner.animate("Jump") # Change to Jump
	FindTarget()
	
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

func update(_delta: float) -> void:
	current_wall_pause_time-=_delta
	time_in_state+=_delta
	
	var target_x = TARGET.global_position.x + randf_range(-range,range)
	var x_distance = abs(target_x - owner.global_position.x)
	
	#Never slam if we are on first jump.
	if(num_jumps_used <= 1):
		return
		
	#If he is in range
	if(x_distance < (check_range*num_jumps_used)):
		#Randomly slam or always slam if needing to.
		var coin_flip = randf_range(1,100) 
		if(coin_flip>60 or num_jumps_used>=max_jumps):
			finished.emit(SLAM)

func physics_update(delta: float) -> void:
	if(!TARGET):
		finished.emit(IDLE)
		return
	
	if owner.is_on_wall: #and not hasReversed:
		owner.velocity.x = -owner.velocity.x  
		#hasReversed = true
		if(owner.velocity.x > 0):
			owner.Flip(false)
		else:
			owner.Flip(true)
		current_wall_pause_time = max_wall_pause_time
		num_jumps_used+=1
		print("I have used: ", num_jumps_used)
		
	#Go down if in air.
	if not owner.is_on_floor():
		owner.velocity.y += gravity * delta
		owner.velocity.y = min(max_velocity, owner.velocity.y)

		
	#If go down, fall
	if(owner.velocity.y > 3):
		finished.emit(FALL)
	
	if(current_wall_pause_time <= 0):
		owner.move_and_slide()
