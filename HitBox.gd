extends Area2D

var our_body
@export var damage = 5
@onready var collision := $CollisionShape2D

func _ready():
	collision.disabled = true
	
func _on_body_entered(body):
	# Check if hitting self or friend
	if body != our_body:
		print("hit a body", body.name)
		if body.has_method("take_hit"):
			body.take_hit(global_position, damage)
			collision.call_deferred("set_disabled", true)
