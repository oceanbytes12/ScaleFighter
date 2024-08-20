#class_name AnnouncerVoice 
extends Node2D

# Called by EnemyTitleAnimator
# Could not get sound to play in correct order otherwise

# Called when the node enters the scene tree for the first time.
func _ready():
	print("AnnouncerCreated")
	$Announcer1.play()
	print("play hit")



func _on_timer_timeout():
	queue_free()
