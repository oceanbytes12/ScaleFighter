extends EnemyState

func enter(_previous_state_path: String, _data := {}) -> void:
	print("Entering Enemy Defeated")
	owner.SetEnemyBodyDamages(false)
	owner.ToggleHurtBox(false)
	owner.animate("Stun")

func physics_update(_delta: float) -> void:
	player.velocity.y += player.gravity * _delta
	player.velocity.x *= 0.95
	player.move_and_slide()
