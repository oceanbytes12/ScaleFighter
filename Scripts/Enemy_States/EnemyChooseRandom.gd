extends EnemyState

@export var CanJump = false
@export var CanSlam = false # Not implemented yet

var TARGET : CharacterBody2D

var inrange = false

func enter(previous_state_path: String, data := {}) -> void:
	owner.animate("Walk")
	FindTarget()
	
func FindTarget():
	TARGET = Player.mainPlayer

func physics_update(delta: float) -> void:
	ChooseAttack()



func _on_attack_range_body_entered(body):
	if body == TARGET:
		inrange = true

func _on_attack_range_body_exited(body):
	if body == TARGET:
		inrange = false

func ChooseAttack():
	# All enemies have the PUNCH ability
	# The others can be toggled
	if !CanJump && !CanSlam:
		finished.emit(PUNCH)
		
	else:
		# Do a random selection of attack
		# Generate a random integer between 0 and 2
		randomize()
		var random_num = randi() % 3

		match random_num:
			0:
				finished.emit(PUNCH)
			1:
				if CanJump:
					finished.emit(JUMP)
				else:
					finished.emit(PUNCH)
			2: 
				if CanSlam:
					finished.emit(JUMP)
				else:
					#finished.emit(SLAM)
					pass #Not implemented yet


		print(random_num)
