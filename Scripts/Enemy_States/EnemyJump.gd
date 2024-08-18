extends EnemyState

var TARGET : CharacterBody2D
const JUMP_VELOCITY = -400.0
var SPEED = 100.0
var gravity = 1000

var inrange = false
var isJumping = false

func enter(previous_state_path: String, data := {}) -> void:
	print("Entered JUMP state")
	owner.animate("Idle") # Change to Jump
	FindTarget()
	
func FindTarget():
	TARGET = Player.mainPlayer

func physics_update(delta: float) -> void:

	var target_vector = Vector2.ZERO
	
	if(TARGET):
		if not isJumping:
			#Jump towards target
			target_vector = TARGET.global_position - owner.global_position
			target_vector = target_vector.normalized() * SPEED 
			owner.velocity.y = JUMP_VELOCITY
			owner.velocity.x = target_vector.x
			isJumping = true
	else:
		print("NO TARGET")
		
	if isJumping:
		# Check if we are on top of the player. Stop moving in x dir if yes
		if (int)(TARGET.global_position.x - owner.global_position.x) == 0:
			owner.velocity.x = 0
			
	# Add the gravity.
	if not owner.is_on_floor():
		owner.velocity.y += gravity * delta
		
	if owner.is_on_floor():
		print("Returning to CHASE state")
		isJumping = false
		finished.emit(CHASE)
		
	owner.move_and_slide()


func _on_attack_range_body_entered(body):
	if body == TARGET:
		inrange = true

func _on_attack_range_body_exited(body):
	if body == TARGET:
		inrange = false
