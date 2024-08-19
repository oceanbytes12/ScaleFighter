class_name HurtBox extends Area2D
@export var sound: AudioStreamPlayer2D

signal take_damage(position,damage, knockback)

func take_hit(hit_position, damage, knockback):
	take_damage.emit(hit_position, damage, knockback)
	if (sound):
				sound.play()
