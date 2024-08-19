extends EnemyState

#@export var CanJump = false
#@export var CanSlam = false # Not implemented yet

var TARGET : CharacterBody2D

var inrange = false

func enter(_previous_state_path: String, _data := {}) -> void:
	owner.animate("Walk")
	FindTarget()
	
func FindTarget():
	TARGET = Player.mainPlayer

func physics_update(delta: float) -> void:
	var target_vector = Vector2.ZERO
	if(TARGET):
		target_vector = TARGET.global_position - owner.global_position
	
	if target_vector.x < 0:
		owner.Flip(true)
	elif(target_vector.x > 0):
		owner.Flip(false)
		
	if(TARGET):
		target_vector = TARGET.global_position - owner.global_position
	else:
		print("NO TARGET")
	target_vector = target_vector.normalized()
	target_vector.y = 0
	
	if (not inrange):
		owner.velocity = target_vector * owner.SPEED
	else:
		finished.emit(PUNCH)
		
	if not owner.is_on_floor():
		owner.velocity.y += owner.GRAVITY * delta

	owner.move_and_slide()


func _on_attack_range_body_entered(body):
	if body == TARGET:
		inrange = true

func _on_attack_range_body_exited(body):
	if body == TARGET:
		inrange = false
