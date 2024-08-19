extends Node2D

# Create random hit effects

func _ready():
	#EventBus.on_damage_at_position.connect(new_particle)
	new_particle()
	
func new_particle():
	var anims = $AnimationPlayer.get_animation_list()
	$AnimationPlayer.play(anims[randi() % anims.size()])
	$Timer.start()

# Use when instantiate a new ParticleGenerator for each hit effect
func _on_timer_timeout():
	queue_free() # Effect object cleanup
