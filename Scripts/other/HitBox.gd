extends Area2D

@export var damage = 1
@export var knockback = 1
@export var startDisabled = true
@export var disableAfterHit = true
@export var sound: AudioStreamPlayer2D
var collision : CollisionShape2D

func _ready():
	collision = get_child(0)
	if(startDisabled):
		collision.disabled = true

func _on_area_entered(area):
	# Check if hitting self or friend
	print(name," is hitting:", area.name)
	if area.owner != owner:
		if area.has_method("take_hit"):
			area.take_hit(global_position, damage * owner.power, knockback*owner.power)
			if (sound):
				sound.play()
			if(disableAfterHit):
				collision.call_deferred("set_disabled", true)
