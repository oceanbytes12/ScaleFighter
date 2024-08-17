extends AnimatedSprite2D

var damage = 20
var hitstun = 100

func _on_animation_finished():
	queue_free()

func set_knockback(knockback_amount):
	hitstun = knockback_amount


func _on_area_2d_body_entered(body):
	# Check if hitting player
	if body is Player:
		if body.has_method("take_hit"):
			body.take_hit(global_position, damage, hitstun)
			#$Attack_hit_sfx.play()
