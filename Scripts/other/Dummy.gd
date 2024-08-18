extends CharacterBody2D

signal take_damage

func _ready():
	$AnimationPlayer.play("idle")

func take_hit(hit_position, damage, knockback):
	var direction = (global_position-hit_position).normalized()
	velocity = direction * 100
	$AnimationPlayer.play("hit")
	take_damage.emit(damage)
