extends Area2D

@export var damage = 1
@export var knockback = 1
@onready var collision := $CollisionShape2D

func _ready():
	collision.disabled = true
	
func _on_body_entered(body):
	# Check if hitting self or friend
	if body != owner:
		if body.has_method("take_hit"):
			body.take_hit(global_position, damage * owner.power, knockback*owner.power)
			collision.call_deferred("set_disabled", true)
