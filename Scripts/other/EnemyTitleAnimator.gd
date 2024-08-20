class_name EnemyTitleAnimator extends Node2D

@export var wordAnimTime = 1.5
@export var countdownAnimTime = 0.6
#@export var announcerVoice := PackedScene
const announcer_SCENE = "res://Scenes/Other/AnnouncerVoice.tscn"

@onready var animator := $AnimationPlayer
# Plays enemy title animation
var play_automatically = false
func _ready():
	if(play_automatically):
		DisplayEnemyTitle("Squirrel")

func DisplayEnemyTitle(enemy_name):
	animator.play(enemy_name)


func TitleSquirrel(firstShown, secondShown):
	firstShown.show()
	await get_tree().create_timer(wordAnimTime).timeout
	firstShown.hide() 
	secondShown.show()
	await get_tree().create_timer(wordAnimTime).timeout
	secondShown.hide()
	TitleCountdown()

func TitleCountdown():
	$Announcer1.play()
	#var packed_scene = preload(announcer_SCENE)
	#var announcer_node = packed_scene.instantiate()
	##var new_scene = preload("res://Scenes/Other/AnnouncerVoice.tscn")
	##var instance = new_scene.instance()
	##get_parent().get_parent().add_child(announcer_node)
	#get_parent().get_parent().add_child(announcer_node)
		
	$Three.show()
	await get_tree().create_timer(countdownAnimTime).timeout
	$Three.hide() 
	$Two.show()
	await get_tree().create_timer(countdownAnimTime).timeout
	$Two.hide() 
	
	$One.show()
	await get_tree().create_timer(countdownAnimTime).timeout
	$One.hide() 
	
	$Fight.show()
	await get_tree().create_timer(wordAnimTime).timeout
	$Fight.hide() 

# Not in use. Leaving in case needed
func _on_timer_timeout():
	pass # Replace with function body.
