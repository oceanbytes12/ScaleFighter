class_name HurtBox extends Area2D

signal take_damage(position,damage, knockback)

func take_hit(hit_position, damage, knockback):
	take_damage.emit(hit_position, damage, knockback)
