extends CharacterBody2D

func _ready():
	$AnimationPlayer.play("idle")

func take_hit(hit_position, damage):
	var direction = (global_position-hit_position).normalized()
	velocity = direction * 100
	$AnimationPlayer.play("hit")
