extends Area2D

var our_body
var damage = 5
@onready var animator := $AnimationPlayer
@onready var collision := $CollisionShape2D

func _ready():
	collision.disabled = true
	
func _on_body_entered(body):
	# Check if hitting self or friend
	if body != our_body:
		print("hit a body", body.name)
		if body.has_method("take_hit"):
			body.take_hit(global_position, damage)
			collision.disabled = true
