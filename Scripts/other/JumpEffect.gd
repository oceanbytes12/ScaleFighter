extends AnimatedSprite2D

func _ready():
	play("Jump")

func _on_animation_finished():
	queue_free()
