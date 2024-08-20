extends PlayerState

@export var blinkAnimator : AnimationPlayer

var is_downed = false
var check_for_downed = false
func enter(_previous_state_path: String, _data := {}) -> void:

	if player.growct == 1:
		$Gecko_med_die.play()
	elif player.growct > 1:
		$Gecko_big_die.play()
	else: 
		$Gecko_little_die.play()

	owner.animate("Hurt")
	is_downed = false
	owner.Blink()
	owner.ToggleHurtBox(false)
	
	await get_tree().create_timer(1).timeout
	check_for_downed = true

func physics_update(_delta: float) -> void:
	if is_downed:
		player.velocity = Vector2.ZERO
	else:
		player.velocity.y += player.gravity * _delta
		player.velocity.x *= 0.95
		
	if not is_downed and player.is_on_floor() and check_for_downed:
		is_downed = true
		owner.animate("Idle")
		await get_tree().create_timer(1).timeout
		owner.animate("Defeated")
		
	player.move_and_slide()

