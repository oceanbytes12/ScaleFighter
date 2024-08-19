class_name HurtBox extends Area2D
@export var sound: AudioStreamPlayer2D
@onready var Collision := $HurtBox

signal take_damage(position,damage, knockback)

func toggle(isOn):
	Collision.call_deferred("set_disabled", !isOn)
	print("Collision Disabled: ", !isOn)

func take_hit(hit_position, damage, knockback):
	take_damage.emit(hit_position, damage, knockback)
	if (sound):
		sound.play()

