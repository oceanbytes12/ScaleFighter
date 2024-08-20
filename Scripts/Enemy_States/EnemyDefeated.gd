extends EnemyState

func enter(_previous_state_path: String, _data := {}) -> void:
	owner.SetEnemyBodyDamages(false)
	owner.ToggleHurtBox(false)
	owner.animate("Stun")
	$Enemy_die.play()

func physics_update(_delta: float) -> void:
	player.velocity.y += player.gravity * _delta
	player.velocity.x *= 0.95
	player.move_and_slide()
